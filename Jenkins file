pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Soumya88a/nimbus-devops-project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "Building application..."'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region us-west-1 update-kubeconfig --name jenkins-proj
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
    }
}
