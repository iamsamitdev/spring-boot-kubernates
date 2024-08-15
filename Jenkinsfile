pipeline {
    agent any

    environment {
      MAVEN_ARGS = "-e clean install"
      DOCKER_IMAGE = 'iamsamitdev/springbootdemo:latest'
      KUBE_CONFIG_PATH = 'C:\\Users\\samit\\.kube\\config'    // เปลี่ยนตามตำแหน่งที่เก็บ kubeconfig บน Jenkins
      KUBE_NAMESPACE = 'default'                              // ชื่อ namespace ที่ใช้ใน Kubernetes
    }

    stages {
        stage('Build Maven Project') {
            steps {
                // รัน Maven เพื่อ build project
                withMaven(maven: 'MAVEN_HOME') {
                    bat "mvn ${MAVEN_ARGS}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                // สร้าง Docker image จาก Dockerfile ที่อยู่ใน project
                bat "docker build -t ${DOCKER_IMAGE} ."

                // ลบ dangling images (images ที่ไม่มี tag)
                bat "docker image prune -f"

                // แสดงรายชื่อ Docker images ทั้งหมดที่มีอยู่หลังจาก build เสร็จ
                bat "docker images"
            }
        }
        stage('Push Docker Image') {
            steps {
                // Login เข้า Docker Hub และ push Docker image ที่สร้างขึ้น
                withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKERHUB_PASSWORD')]) {
                    bat "docker login -u iamsamitdev -p %DOCKERHUB_PASSWORD%"
                    bat "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // ใช้ kubectl apply เพื่อ deploy หรืออัปเดต resource ใน Kubernetes จาก deployment.yaml
                bat "kubectl --kubeconfig=${KUBE_CONFIG_PATH} apply -f deployment.yaml -n ${KUBE_NAMESPACE}"
                
                // ตรวจสอบสถานะของ deployment
                bat "kubectl --kubeconfig=${KUBE_CONFIG_PATH} rollout status deployment/springboot-app -n ${KUBE_NAMESPACE}"
            }
        }
    }

    post {
        always {
            // ทำความสะอาด workspace หลังการรัน pipeline เสร็จ
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
