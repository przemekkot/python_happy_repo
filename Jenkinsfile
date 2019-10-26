pipeline {

    agent {
          dockerfile {
               filename 'Dockerfile'
               //args '-v keys:/home/goblin/.ssh'
               //args '-v /etc/passwd:/etc/passwd'
               //this probably breaks build at the end: args '--rm'
               reuseNode true
          }
                     //add a docker file for this stage only
    }

    options {
          //skipDefaultCheckout(true)
          // Keep the 10 most recent builds
          buildDiscarder(logRotator(numToKeepStr: '10'))
          timestamps()
    }

    environment {
      PYPI_USER=credentials('pypi_user')
      PYPI_PASS=credentials('pypi_pass')
      PYPI_REPO='https://test.pypi.org/legacy/'
      JENKINS="True"
    }

    stages {
        stage('Code check') {
            steps {
                echo 'Code pull'
                sh 'make lint'
                }
        }
        stage('Basic tests') {
            steps {
                echo 'Testing'
                sh 'make test-xunit'

                echo 'Coverage'
                sh 'make coverage'
            }
            post {
                always {
                       archiveArtifacts allowEmptyArchive: true, artifacts: 'build/*_pytest.xml', fingerprint: true
                       //TODO: add saving stuff for coverage
                }
            }
        }
        stage('Push to Tests branch') {
            steps {
                echo 'Pushing to tests'
                sshagent(['Blue']) {
                   sh 'git fetch --all'
                   sh 'git remote -v'
                   //sh 'git remote add main git@192.168.8.106:/srv/happy_repo.git'
                   sh 'git checkout tests'
                   sh 'git merge dev'
                   sh 'git push main tests'
                }
            }
        }
        stage('Build package') {
            when {
                anyOf { branch 'dev'; branch 'master' }
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo 'Building'
                sh 'make dist'
            }
            post {
                always {
                    // Archive unit tests for the future
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'dist/*whl', fingerprint: true
                    echo 'Results saved'
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
                // here do all the stuff for deploying service online
            }
        }

        stage('Release') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
                branch 'release'
                tag 'release-*'
            }
            steps {
                echo 'Releasing'
                // here do all the stuff for publishing package online

                //sh 'echo -e "[pypi]" >> ~/.pypirc'
                //sh 'echo -e "repository: https://test.pypi.org/legacy/" >> ~/.pypirc'
                //sh 'echo -e "username = $PYPI_USER" >> ~/.pypirc'
                //sh 'echo -e "password = $PYPI_PASS" >> ~/.pypirc'

                // .pypirc is in jenkins folder
                sh 'make dist-upload PYPI_REPO=$PYPI_REPO PYPI_USER=$PYPI_USER PYPI_PASS=$PYPI_PASS'
            }
        }    
    }
    post {
        always {
            //clean the container
            //cleaning the dockers 
            //this should be done somewhere: sh 'docker system prune --volumes -f'
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
