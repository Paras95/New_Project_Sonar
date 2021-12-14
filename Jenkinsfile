        
pipeline
{
  agent any
  
   
      tools
      {
      maven 'maven'
      }

     stages

     {
        stage('Build')
        {
         

          steps
         {

         sh 'mvn clean install'
         echo "Building......"
         sh 'ls'
         archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
         

          }
          
        }

         stage('Test')
         {
           steps{

           echo "testing...."
           sh 'mvn test'
           archiveArtifacts artifacts: '**/target/surefire-reports/*.xml', fingerprint: true
           junit '**/target/surefire-reports/*.xml'
           withSonarQubeEnv(installationName: 'sonar')
           {
            sh './mvnw clean sonar:sonar'

           }

           }


         

         }

         stage('Deploye')
         {
          steps{

           echo "Deploying...with neww branch"

          }


         }


      }
}
