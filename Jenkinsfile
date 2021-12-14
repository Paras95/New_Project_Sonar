pipeline
{
  agent none

  /*triggers {
        pollSCM('* * * * *')
    }*/

  options
  {
    buildDiscarder(logRotator(numToKeepStr: '4')) 
  }

  parameters
  {

      string(name: 'PERSON', defaultValue: 'Jenkins', description: 'Who should i say hello to')
      text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

      booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

      choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

      password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
  }
   environment
        {
           For_Sequential = 'some_value'
           My_Password = credentials('6ad7401e-6579-4543-b948-ff2bd52cb366')

        }
      tools
      {
      maven 'maven'
      }

     stages

     {
        stage('Build')
        {
         agent any

          steps
         {

         sh 'mvn clean install'
         echo "Building......"     

               }
          
        }

         stage('Test')
         {

         

         }


      }
