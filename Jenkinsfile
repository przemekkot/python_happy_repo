pipeline {
    agent any

    options {
          //skipDefaultCheckout(true)
          // Keep the 10 most recent builds
          buildDiscarder(logRotator(numToKeepStr: '10'))
          timestamps()
    }

    environment {
      PYPI_USER=credentials('pypi_user') // assume same login and pass for test and main
      PYPI_PASS=credentials('pypi_pass')
      JENKINS="True"
    }

    stages {
        stage('Init and Code check') {
            steps {
                echo 'Code pull'
                sh 'python3 -m virtualenv .venv; source .venv/bin/activate'
                sh 'pip install --user -r requirements_dev.txt'
                sh 'make lint'
                }
        }
        stage('Basic tests') {
            steps {
                echo 'Testing'

                sh 'make test-all'
                sh 'make test-xunit'


                echo 'Coverage'
                sh 'make coverage'
            }
            post {
                always {
                       archiveArtifacts allowEmptyArchive: true, artifacts: 'build/*_pytest.xml', fingerprint: true
                }
            }
        }
        stage('Push to Tests branch') {
            when {
                 anyOf {
                       branch 'dev'
                 }
            }
            steps {
                echo 'Pushing to tests'
                sshagent(['Blue']) {
                   sh 'make push-to-test'
                }
            }
        }
        stage('Build test package and publish') {
            when {
                anyOf { branch 'tests'; }
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo 'Building'
                sh 'make dist'
                sh 'make dist-test-upload PYPI_USER=$PYPI_USER PYPI_PASS=$PYPI_PASS'
            }
            post {
                always {
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'dist/*whl', fingerprint: true
                    echo 'Results saved'
                }
                success {
                    echo 'Pushing to master'
                    sshagent(['Blue']) {
                        sh 'make push-to-master'
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                 branch 'master'
            }
            steps {
                echo 'Deploying'
                echo 'Pushing to github master'
                sshagent(['Red']) {
                     sh 'make push-to-przemek'
                }
            }
        }
        stage('Release') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
                branch 'master'
                tag 'release*'
            }
            steps {
                echo 'Releasing'
                sh 'make dist'
                sh 'make dist-upload PYPI_USER=$PYPI_USER PYPI_PASS=$PYPI_PASS'
            }
            post {
                 success {
                     sshagent(['Oren']) {
                         sh 'make push-to-oren'
                     }
                 }
            }
        }    
    }
    post {
        always {
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
