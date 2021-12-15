        

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
       /* stage('outside'){
          steps{
            /*script{
              paras()
               sh ''' curl -sSf -u "admin:ParasSharma@234" \
                   -X PUT \
                   -T pom.xml \
                   'http://172.18.0.4:8082/artifactory/paras/1.0/pom.xml;name=jenkins;key=fromdockerjenkins'
            
            
                  '''
                  
            }
            
          }
        }*/
        stage('Build')
        {
         

          steps
         {

         sh 'mvn clean install'
         echo "Building......"
         sh 'ls -al'
         archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
         stash includes: '**/target/*.jar', name: 'jar1'
        

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
                stash includes: '**/target/surefire-reports/*.xml', name: 'xml1'
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

         stage('Artifacts')
         {
          steps
          {
              script
              {
                def server = Artifactory.server 'ART'
                def downloadSpec = """{
                          "files": [
                             {
                                "pattern": "paras/pom.xml",
                                "target": "bazinga/"
                             }
                          ]
                        }"""
                server.download spec: downloadSpec 
                //def server = Artifactory.server 'ART'
                unstash 'jar1'
                unstash 'xml1'

                def uploadSpec = """{
                        "files": [
                                  {
                                    "pattern": "my-app-1.0-SNAPSHOT.jar",
                                    "target": "paras1/1.0/my-app-1.0-SNAPSHOT.jar" 
                                  },
                                  {
                                    "pattern": "TEST-com.mycompany.app.AppTest.xml",
                                    "target": "paras1/1.0/TEST-com.mycompany.app.AppTest.xml"
                                  }
                            ]
                      }"""
                server.upload spec: uploadSpec 



              }

          }



         }


      }
}


// helper

def paras(){
  echo "paras from outside the pipelne"
}