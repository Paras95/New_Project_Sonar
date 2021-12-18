        

//def name 


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
            script{
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

         stage('Jfrog_Artifactory')
         {
          steps
          {
              script
              {
                def server = Artifactory.server 'ART'
               /* def downloadSpec = """{
                          "files": [
                             {
                                "pattern": "paras/pom.xml",
                                "target": "bazinga/"
                             }
                          ]
                        }"""
                server.download spec: downloadSpec*/
                sh 'ls -al'
                def uploadSpec = """{
                        "files": [
                                  {
                                    "pattern": "*.xml",
                                    "target": "new/1.0/*.xml",
                                    "props": "filter-by-this-prop=yes"
                                  },
                                  {
                                    "pattern": "**/*.jar",
                                    "target": "new/1.0/*.jar",
                                    "props": "filter-by-this-prop=yes11"
                                  }

                            ]
                      }"""
                server.upload spec: uploadSpec 



          }



         }


      }
}

}


/*
// helper

def paras(){
  echo "paras from outside the pipelne"
}*/
