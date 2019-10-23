pipeline {

    agent {
          label 'python-builder'
    }

    options {
          //skipDefaultCheckout(true)
          // Keep the 10 most recent builds
          buildDiscarder(logRotator(numToKeepStr: '10'))
          timestamps()
    }

    environment {
      JENKINS="True"
    }

    stages {
        stage('Code pull') {
            agent {
               dockerfile {
                   filename 'Dockerfile'
                   args '--rm'
                   reuseNode true
               }
                     //add a docker file for this stage only
            }

            steps {
                echo 'Code pull'
                sh 'make lint'
                sh 'echo $JENKINS'
                }
        }
        stage('Test') {
            steps {
                echo 'Testing'
            }
        }
        stage('Build package') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo 'Building'
            }
            post {
                always {
                    // Archive unit tests for the future
                    //archiveArtifacts allowEmptyArchive: true, artifacts: 'dist/*whl', fingerprint: true)
                    echo 'Results saved'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
            }
        }

        stage('Release') {
            steps {
                echo 'Releasing'
            }
        }    
    }
    post {
        always {
            //clean the container
            sh 'docker system prune --volumes -f'
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
