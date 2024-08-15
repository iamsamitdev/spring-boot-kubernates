pipeline {
    agent any

    environment {
      MAVEN_ARGS = "-e clean install"
      DOCKER_IMAGE = 'iamsamitdev/springbootdemo:latest'
      // KUBE_CONFIG_PATH = 'C:\\path\\to\\kubeconfig'           // เปลี่ยนตามตำแหน่งที่เก็บ kubeconfig บน Jenkins
      // KUBE_NAMESPACE = 'default'                              // ชื่อ namespace ที่ใช้ใน Kubernetes
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
        // stage('Push Docker Image') {
        //     steps {
        //         // Login เข้า Docker Hub และ push Docker image ที่สร้างขึ้น
        //         withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKERHUB_PASSWORD')]) {
        //             bat "echo %DOCKERHUB_PASSWORD% | docker login -u yourdockerhubusername --password-stdin"
        //             bat "docker push ${DOCKER_IMAGE}"
        //         }
        //     }
        // }
        // stage('Deploy to Kubernetes') {
        //     steps {
        //         // ใช้ kubectl เพื่อ deploy image ที่สร้างไปยัง Kubernetes cluster
        //         bat "kubectl --kubeconfig=${KUBE_CONFIG_PATH} set image deployment/springboot-app springboot-container=${DOCKER_IMAGE} -n ${KUBE_NAMESPACE}"
        //         bat "kubectl --kubeconfig=${KUBE_CONFIG_PATH} rollout status deployment/springboot-app -n ${KUBE_NAMESPACE}"
        //     }
        // }
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
