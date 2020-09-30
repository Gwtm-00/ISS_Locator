pipeline {
<<<<<<< HEAD
     agent any
     stages {
         stage('Build') {
              steps {
                  sh 'echo Building...'
              }
         }
         stage('Lint Dockerfile') {
            steps {
                script {
                    docker.image('hadolint/hadolint:latest-debian').inside() {
                            sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
                            sh '''
                                lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
                                if [ "$lintErrors" -gexit "0" ]; then
                                    echo "Errors have been found, please see below"
                                    cat hadolint_lint.txt
                                    exit 1
                                else
                                    echo "There are no erros found on Dockerfile!!"
                                fi
                            '''
                    }
                }
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
            //  sh '''
            //      docker build -t andresaaap/cloudcapstone:$BUILD_ID .
            //     '''
                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                    sh "docker tag isslocator gwtm11/isslocator"
                    sh 'docker push gwtm11/isslocator'
                 }
             }
         }
        //  stage('Push Docker Image') {
        //       steps {
        //           withDockerRegistry([url: "", credentialsId: "docker-hub"]) {
        //               sh "docker tag isslocator gwtm11/isslocator"
        //               sh 'docker push gwtm11/isslocator'
        //           }
        //       }
        //  }
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws-static', region: 'us-west-2') {
                      sh "aws eks --region us-west-2 update-kubeconfig --name gwtmUdacityCapstone"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:307973489560:cluster/gwtmUdacityCapstone"
                      sh "kubectl apply -f deployment.yaml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/isslocator"
                  }
              }
=======
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo Building...'
      }
    }

    stage('Lint Dockerfile') {
      steps {
        script {
          docker.image('hadolint/hadolint:latest-debian').inside() {
            sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
            sh '''
lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
if [ "$lintErrors" -gt "0" ]; then
echo "Errors have been found, please see below"
cat hadolint_lint.txt
exit 1
else
echo "There are no erros found on Dockerfile!!"
fi
'''
          }
>>>>>>> b38220684b642c09674796736cd46da7aa5b9ab9
        }

      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build --tag=isslocator .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
          sh 'docker tag isslocator gwtm11/isslocator'
          sh 'docker push gwtm11/isslocator'
        }

      }
    }

    stage('Deploying') {
      steps {
        echo 'Deploying to AWS...'
        withAWS(credentials: 'aws-static', region: 'us-west-2') {
          sh 'aws eks --region us-west-2 update-kubeconfig --name gwtmUdacityCapstone'
          sh 'kubectl config use-context arn:aws:eks:us-west-2:307973489560:cluster/gwtmUdacityCapstone'
          sh 'kubectl apply -f deployment.yaml'
          sh 'kubectl get nodes'
          sh 'kubectl get deployments'
          sh 'kubectl get pod -o wide'
          sh 'kubectl get service/isslocator'
        }

      }
    }

    stage('Checking if app is up') {
      steps {
        echo 'Checking if app is up...'
        withAWS(credentials: 'aws-static', region: 'us-west-2') {
          sh 'curl aea02ae0dfe5f483f9980cc9b59326bf-613299129.us-west-2.elb.amazonaws.com:80'
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