pipeline {
    agent {
           dockerfile true
           
           //docker {
           //    image 'python:3.8-slim'
           //}
        }
    stages {
        stage('Preparation') { // for display purposes
            steps {
                //sshagent (credentials: ['Blue']) {
                //git 'git:flaron95t@172.17.0.1:/srv/happy_repo.git'
                //git branch: 'master',
                git credentialsId: 'Blue',
                    url: 'git@192.168.8.106:/srv/happy_repo.git', 
                    branch: 'dev'
                // }

               // Get some code from a GitHub repository
               sh 'sudo pip install --user -r requirements_dev.txt'
               sh 'make lint'
            }
        }
    }
//  stage('Results') {
//      junit '**/target/surefire-reports/TEST-*.xml'
//      archiveArtifacts 'target/*.jar'
//   }
}
