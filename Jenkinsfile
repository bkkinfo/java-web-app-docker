node{
     
    stage('SCM Checkout'){
        git url: 'https://github.com/bkkinfo/java-web-app-docker.git'
    }
    
    stage(" Maven Clean Package"){
      def mavenHome =  tool name: "maven", type: "maven"
      def mavenCMD = "${mavenHome}/bin/mvn"
      sh "${mavenCMD} clean package"
      
    } 
    stage('SonarQube Analysis'){
        def mavenHome = tool name: 'maven' , type: 'maven'
        withSonarQubeEnv('sonar'){
            sh "${mavenHome}/bin/mvn sonar:sonar -Dsonar.projectKey=sonar -Dsonar.host.url=http://13.87.153.253:9000/ananthan/sonar/ -Dsonar.login=4582750b30d9ba259d6dfad73518b4204cec3dba"
        }
    }
    
    
    stage('Build Docker Image'){
        def dockerHome = tool 'docker'
        env.PATH = "${dockerHome}/bin:${env.PATH}"
        sh 'docker build -t dockerhandson/java-web-app .'
    }
    
    stage('Push Docker Image'){
        withCredentials([string(credentialsId: 'Docker_Hub_Pwd', variable: 'Docker_Hub_Pwd')]) {
          sh "docker login -u dockerhandson -p ${Docker_Hub_Pwd}"
        }
        sh 'docker push dockerhandson/java-web-app'
     }
     
      stage('Run Docker Image In Dev Server'){
        
        def dockerRun = ' docker run  -d -p 8080:8080 --name java-web-app dockerhandson/java-web-app'
         
         sshagent(['DOCKER_SERVER']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.20.72 docker stop java-web-app || true'
          sh 'ssh  ubuntu@172.31.20.72 docker rm java-web-app || true'
          sh 'ssh  ubuntu@172.31.20.72 docker rmi -f  $(docker images -q) || true'
          sh "ssh  ubuntu@172.31.20.72 ${dockerRun}"
       }
       
    }
     
     
}
