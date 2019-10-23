pipeline {
    agent {
        node {
            label 'docker'
        }
    }

    stages {
        stage('Preparation') { // for display purposes
            steps {
            }
        }

        stage('Dev branch pipeline') { // for display purposes
            deleteDir()
            when {
                branch "dev"
            }

            agent {
                dockerfile {
                    filename 'Dockerfile'
                }
                //add a docker file for this stage only
            }

            steps {
                //git branch: 'master',
                git credentialsId: 'Blue',
                    url: 'git@192.168.8.106:/srv/happy_repo.git',
                    branch: 'dev'

                // do some linting and testing
                sh 'make lint'
                sh 'make test'
            }
            post {
                success {
                    sshagent (credentials: ['Blue']){
                        sh 'git fetch origin test'
                        sh 'git checkout test'
                        sh 'git merge dev'
                        sh 'git push origin test'
                    }
                }
            }
        }

        stage('Test branch pipeline') { // for display purposes
            deleteDir()
            when {
                branch "test"
            }

            agent {
                dockerfile {
                    filename 'Dockerfile-build'
                }
            }
            steps {
                deleteDir()
                //git branch: 'master',
                git credentialsId: 'Blue',
                    url: 'git@192.168.8.106:/srv/happy_repo.git',
                    branch: 'test'

                // do some linting and testing
                sh 'make build'
                sh 'make test-build'
                sh 'make d'
                sh ''
            }
            post {
                success {
                    sshagent (credentials: ['Blue']) {
                        sh 'git fetch origin master'
                        sh 'git checkout master'
                        sh 'git merge test'
                        sh 'git push origin master'
                    }
                }
            }
        }


        stage('Master branch pipeline') { // for display purposes
            deleteDir()
            when {
                allOf {
                    branch "master"
                    tag "release"
                }
            }

            agent {
                dockerfile {
                    filename 'Dockerfile-build'
                }
            }
            steps {
                deleteDir()
                //git branch: 'master',
                git credentialsId: 'Blue',
                    url: 'git@192.168.8.106:/srv/happy_repo.git',
                    branch: 'master'

                // do some linting and testing
                sh 'make build'
                sh 'make dist'
            }
            def version = sh 'cat .version'
            post {
                success {
                    sshagent (credentials: ['Blue']) {
                        sh 'git fetch origin master'
                        sh 'git checkout master'
                        sh 'git merge test'
                        sh 'git tag ${version}'
                        sh 'git push origin ${version}'
                    }
                }
            }
        }
        stage('Release branch pipeline') { // for display purposes
            deleteDir()
            when {
                branch "release"
            }

            agent any
            steps {
                //git branch: 'master',
                git credentialsId: 'Blue',
                    url: 'git@192.168.8.106:/srv/happy_repo.git',
                    branch: 'release'

                // do some linting and testing
                sshagent (credentials: ['Github']) {
                    sh 'git push github ${version}'
                }
            }
        }
    }
}
