pipeline {
    agent { label 'slave' }
    options {
        timestamps()
        timeout(25)
        retry(1)
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
    }
    environment {
        grafclouds_dtr_user= credentials('grafclouds_dtr_user')
        grafclouds_dtr_password= credentials('grafclouds_dtr_password')
        git_repo_name = GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
    }
    stages {
        stage('Build Dockerfile') {    
            agent { label 'slave' }      
            steps {                
                    sh 'docker build -t grafclouds/$git_repo_name:latest .'
            }
        }
        stage('Push to DTR') {    
            agent { label 'slave' }      
            steps {                
                    sh 'docker login --username $grafclouds_dtr_user --password $grafclouds_dtr_password' 
                    sh 'docker push grafclouds/$git_repo_name:latest'
            }
        }
    }
    post {
        success {
            slackSend channel: '#mydexpay', color: 'good', message: "$git_repo_name kodları sunucuya aktarıldı!  \n*JenkinsJob:* $BUILD_URL \n*GitHubUrl:* $GIT_URL \n*CommitBy:* $GIT_COMMITTER_NAME"
        }
        failure {
            slackSend channel: '#mydexpay', color: 'danger', message: "$git_repo_name kodları sunucuya aktarılamadı!  \n*JenkinsJob:* $BUILD_URL \n*GitHubUrl:* $GIT_URL \n*CommitBy:* $GIT_COMMITTER_NAME"
        }
    }
        
}
