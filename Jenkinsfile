pipeline {
     agent any
     stages {
         stage('Build') {
              steps {
                  sh 'echo Building...'
              }
         }
         stage('Lint Dockerfile') {
            steps {
                // script {
                //     docker.image('hadolint/hadolint:latest-debian').inside() {
                //             sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
                //             sh '''
                //                 lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
                //                 if [ "$lintErrors" -gexit "0" ]; then
                //                     echo "Errors have been found, please see below"
                //                     cat hadolint_lint.txt
                //                     exit 1
                //                 else
                //                     echo "There are no erros found on Dockerfile!!"
                //                 fi
                //             '''
                //     }
                sh 'make lint'
                // }
            }
        }     
         stage('Build Docker Image') {
              steps {
                  sh 'docker build --tag=isslocator .'
              }
         }
         stage('Push Docker Image') {
                steps {
                   withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){

                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker tag isslocator gwtm11/isslocator"
                    sh 'docker push gwtm11/isslocator'
                 }
             }
         }
         stage('creating kube config file'){
             steps{
                 withAWS(credentials: 'aws-static', region: 'us-west-2') {
                     sh "aws eks --region us-west-2 update-kubeconfig --name capstonecluster"
                 }
             }
         }
         stage('Deploying to EKS') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws-static', region: 'us-west-2') {
                      
                      sh "aws eks --region us-west-2 update-kubeconfig --name capstonecluster"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:307973489560:cluster/capstonecluster"
                      sh "kubectl apply -f deployment.yaml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/isslocator"
                  }
              }
         }
         stage('Checking if app is up') {
            steps {
                echo 'Checking if app is up...'
                withAWS(credentials: 'aws-static', region: 'us-west-2') {
                    sh 'curl ad52df0d5807b40d0901f06ea6c26afb-645653928.us-west-2.elb.amazonaws.com:80'
                }

              }
         }

    stage('Cleaning up') {
      steps {
        echo 'Cleaning up...'
        sh 'docker system prune'
      }
    }

  }
}