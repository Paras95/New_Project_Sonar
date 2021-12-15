        

def name 


pipeline
{
  agent any
  
   
      tools
      {
      maven 'maven'
      }

     stages

     {
        stage('outside'){
          steps{
            script{
              paras()
              sh ''' curl -sSf -u "admin:ParasSharma@234" \
                   -X PUT \
                   -T pom.xml \
                   'http://localhost:8082/example-repo-local/pom.xml'
                   '''
            }
          }
        }
        stage('Build')
        {
         

          steps
         {

         sh 'mvn clean install'
         echo "Building......"
         sh 'ls -al'
         archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
        

          }
          
        }

         stage('Test')
         {
           steps{
             script{
                echo "testing...."
                sh 'mvn test'
                archiveArtifacts artifacts: '**/target/surefire-reports/*.xml', fingerprint: true
                def test = junit '**/target/surefire-reports/*.xml'
                withSonarQubeEnv(installationName: 'sonar')
                {
                  sh 'mvn clean sonar:sonar'

                }
           
             }
           }


         

         }

         stage('Deploye')
         {
          steps{

           echo "Deploying..."

          }


         }


      }
}


// helper

def paras(){
  echo "paras from outside the pipelne"
}