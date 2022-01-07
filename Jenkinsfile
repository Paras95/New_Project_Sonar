        

//def name 


pipeline
{
  agent any
  
   
      tools
      {
      maven 'maven'
      terraform 'Terraform'
      }
      

     stages

     {
       stage('az login')
      {

        steps
        {
         script{
           
          withCredentials([azureServicePrincipal('6fd10f2f-770f-46c9-a679-b62cbc48b647')]) {
            sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
            sh 'az account set -s $AZURE_SUBSCRIPTION_ID'
            sh 'az resource list'
            sh 'terraform init'
            sh 'terraform plan'
            sh 'terraform apply --auto-approve'

         }
        }

        }
      }
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
          echo "Building......"
         //sh 'mvn clean install'
         sh 'ls -al'
       //  archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
        
          }
          
        }

         stage('Test')
         {
           steps{
             script{
                echo "testing...."
                sh 'mvn test'
              //  archiveArtifacts artifacts: '**/target/surefire-reports/*.xml', fingerprint: true
                //def test = junit '**/target/surefire-reports/*.xml'
                withSonarQubeEnv(installationName: 'sonar')
                {
                  sh 'mvn clean sonar:sonar'

                }
              sh 'ls -al'
             }
           }

         }

         stage('Jfrog_Artifactory')
         {
          steps
          {
            sh 'mvn clean install'
      
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
                sh '''
                cd target
                ls -al
                '''
                
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
                archiveArtifacts artifacts: '**/target/surefire-reports/*.xml', fingerprint: true
                sh 'ls -al'
                def uploadSpec = """{
                        "files": [
                                  {
                                    "pattern": "pom.xml",
                                    "target": "new/1.0/pom.xml",
                                    "props": "filter-by-this-prop=yes"
                                  },
                                  {
                                    "pattern": "target/my-app-1.0-SNAPSHOT.jar",
                                    "target": "new/1.0/my-app-1.0-SNAPSHOT.jar",
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
