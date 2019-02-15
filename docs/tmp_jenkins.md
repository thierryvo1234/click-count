# How to run Jenkins with Docker

How to use this image
docker run -p 8081:8080 -p 50000:50000 jenkins
This will store the workspace in /var/jenkins_home. All Jenkins data lives in there - including plugins and configuration. You will probably want to make that a persistent volume (recommended):
Because you should think whether you want to just run the docker, 
or maybe you want to attach the $JENKINS_HOME path to your local system. 
With this option, you will be able to easily access all files (including workspaces, plugin directory and more) 
and you never lose these files. 
If your container dies, all data will be safe.

docker run -p 8081:8080 -p 50000:50000 -v /apps/jenkins_home:/var/jenkins_home jenkins
This will store the jenkins data in /apps/jenkins_home (/your/home) on the host. Ensure that /your/home is accessible by the jenkins user in container (jenkins user - uid 1000) or use -u some_other_user parameter with docker run.


By default, Jenkins docker image uses a user with the UID 1000 (user/group = jenkins/jenkins). So if you create a directory with another owner, docker will return the following error during the container creation:
The solution is very easy – directory you choose for the $JENKINS_HOME should have the owner with the UID 1000. If you don’t have such user in your system, just create it
groupadd jenkins
In that case, the easy solution is to change owner of the chosen directory to 1000:1000



In our case:
docker run -d -p 8081:8080 -p 50000:50000 --name jenkins -v /apps/jenkins:/var/jenkins_home jenkins/jenkins:lts 

Short description:

docker run -d – it runs container in the background
- -v /var/jenkins_home:/var/jenkins_home:z – it attaches the container’s directory at the local system directory and it sets up appropriate SELinux fcontext. 
It maps the /var/jenkins_home directory in the container to the Docker volume with the name jenkins_home. If this volume does not exist, then this docker run command will automatically create the volume for you. This option is required if you want your Jenkins state to persist each time you restart Jenkins (via this docker run … command). 
If you do not specify this option, then Jenkins will effectively reset to a new instance after each restart.
Notes: The jenkins-data volume could also be created independently using the docker volume create command:
docker volume create jenkins-data
Instead of mapping the /var/jenkins_home directory to a Docker volume, you could also map this directory to one on your machine’s local file system. For example, specifying the option
-v $HOME/jenkins:/var/jenkins_home would map the container’s /var/jenkins_home directory to the jenkins subdirectory within the $HOME directory on your local machine, which would typically be /Users/<your-username>/jenkins or /home/<your-username>/jenkins.
( Optional ) /var/run/docker.sock represents the Unix-based socket through which the Docker daemon listens on. This mapping allows the jenkinsci/blueocean container to communicate with the Docker daemon, which is required if the jenkinsci/blueocean container needs to instantiate other Docker containers. This option is necessary if you run declarative Pipelines whose syntax contains the agent section with the docker parameter

 
- -p 8081:8080 – it exposes container’s port 8080 to the local system port 8081
- -p 50000:50000 – same as above, but with the port 50000. This is only necessary if you have set up one or more JNLP-based Jenkins agents on other machines, which in turn interact with the jenkinsci/blueocean container (acting as the "master" Jenkins server, or simply "Jenkins master"). 
- –name jenkins – display name of our container
- jenkins/jenkins:lts – it tells “use the LTS version of Jenkins from the jenkins docker repository”


## Accessing the Jenkins Docker container
```console
docker exec -it jenkins bash
```

## Accessing the Jenkins console log through Docker logs
```console
docker logs <docker-container-name>
```

# Talk to GitHub

The first step is to configure Jenkins to talk to GitHub.  You will need to download and install the GitHub plugin (I am using version 1.8 as of this writing).  Manage Jenkins -> Manage Plugins -> Available -> GitHub plugin

## Automatic Mode (Jenkins manages hooks for jobs by itself)
In this mode, Jenkins will automatically add/remove hook URLs to GitHub based on the project configuration in the background. You'll specify GitHub OAuth token so that Jenkins can login as you to do this.

Step 1. Go to the global configuration and add GitHub Server Config.

In order for builds to be triggered automatically by PUSH and PULL REQUEST events, a Jenkins Web Hook needs to be added to each GitHub repository or organization that interacts with your build server. You (or someone who can help) will need admin permissions on that repository.

Step-by-Step Guide
For each GitHub repository or organization that you need to configure, perform the following steps:

Navigate to the "Settings" tab.
Select the "Webhooks" option on the left menu
Click "Add Webhook"
For "Payload URL":
Use the address for the Jenkins server instance (e.g. http://myjenkins.com)
Add /github-webhook/ to the end of it.
Make sure to include the last /!
example: http://myjenkins.com/github-webhook/
Select "application/json" as the encoding type
Leave "Secret" blank (unless a secret has been created and configured in the Jenkins "Configure System -> GitHub plugin" section)
Select "Let me select individual events"
Enable PUSH event
Enable Pull Request event
Make sure "Active" is checked
Click "Add Webhook"
Jenkins will now receive push and pull request notifications for that repository, and related builds will be automatically triggered.


# Pipeline

Jenkins is an open source continuous integration server that provides the ability to continuously perform automated builds and tests. Several tasks can be controlled and monitored by Jenkins, including pulling code from a repository, performing static code analysis, building your project, executing unit tests, automated tests and/or performance tests, and finally, deploying your application. These tasks typically conform a continuous delivery pipeline.

 Pipelines are a suite of Jenkins plugins. Pipelines can be seen as a sequence of stages to perform the tasks just detailed, among others, thus providing continuous releases of your application. The concept “continuous” is relative to your application and/or environment: In some cases releases can be performed on a daily basis while for others could be weekly, depending on your business needs. In some situations, a critical fix for example, it would be desirable to have your environment ready to release your application as soon as possible. Pipelines provide a way to do this through an automated process.

## How to Create Your Jenkins Pipeline
1. First, log on to your Jenkins server and select “New Item” from the left panel:
![jenkins_pipeline_new_item](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/pipe1.png)

2. Next, enter a name for your pipeline and select “Pipeline” from the options. Click “Ok” to proceed to the next step:
![jenkins_pipeline_new_item2](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/pipe2.png)
3. You can now start working your Pipeline script:

![jenkins_pipeline_new_item3](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/pipe3.png)

The red box in the middle is where you can start writing your script, which will be explained now.

# Creating Your Jenkins Pipeline Script
 
Pipelines has specific sentences or elements to define script sections, which follow the Groovy syntax.

Node Blocks
```console
node {
}
```

The first block to be defined is the “node”:

node{
  stage ('Build') {
 
    git url: 'https://github.com/cyrille-leclerc/multi-module-maven-project'
 
    withMaven(
        // Maven installation declared in the Jenkins "Global Tool Configuration"
        maven: 'M3',
        // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
        // Maven settings and global settings can also be defined in Jenkins Global Tools Configuration
        mavenSettingsConfig: 'my-maven-settings',
        mavenLocalRepo: '.repository') {
 
      // Run the maven build
      sh "mvn clean install"
 
    } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe & FindBugs reports...
  }
}




Jenkinsfile (Declarative Pipeline)
pipeline {
    agent any
    tools {
        maven 'Maven 3.3.9'
        jdk 'jdk8'
    }
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml' 
                }
            }
        }
        stage ('Build project') {
steps {
dir("project_templates/java_project_template"){
sh 'mvn clean verify
 
}
}
}
    }
}


  stage('Build') {
    withMaven(maven: 'Maven 3') {
      dir('app') {
        sh 'mvn clean package'
        dockerCmd 'build --tag automatingguy/sparktodo:SNAPSHOT .'
      }
    }
  }
  
  
  stage ('SonarQube Analysis'){
steps{
dir("project_templates/java_project_template"){
withSonarQubeEnv('SonarQube5.3') {
sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
}
}
}
}



  node {

   stage('Preparation') {  

      sh 'mvn archetype:generate -B ' +
      '-DarchetypeGroupId=org.apache.maven.archetypes ' +
      '-DarchetypeArtifactId=maven-archetype-quickstart ' +
      '-DgroupId=com.company -DartifactId=myproject'
     

   }
   stage('Build') {
       
      dir ('myproject') {
            sh 'mvn clean install test'
      } 
      
   }
   stage('Archive') {
           dir ('myproject/target') {
           archive '*.jar'
      } 
     
   }   
}




pipeline {
  agent any

  tools {
    maven 'mvn-3.5.2'
  }

  stages {
    stage('Build') {
      steps {
        sh 'mvn package'
      }
    }
    
    stage('Make Container') {
      steps {
      sh "docker build -t snscaimito/ledger-service:${env.BUILD_ID} ."
      sh "docker tag snscaimito/ledger-service:${env.BUILD_ID} snscaimito/ledger-service:latest"
      }
    }
    
    stage('Check Specification') {
      steps {
        sh "chmod o+w *"
        sh "docker-compose up --exit-code-from cucumber --build"
      }
    }
  }

  post {
    always {
      archive 'target/**/*.jar'
      junit 'target/**/*.xml'
      cucumber '**/*.json'
    }
    success {
      withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh "docker login -u ${USERNAME} -p ${PASSWORD}"
        sh "docker push snscaimito/ledger-service:${env.BUILD_ID}"
        sh "docker push snscaimito/ledger-service:latest"
      }
    }
  }
}



pipeline {
  agent any
  stages {
    stage('Unit Test') { 
      steps {
        sh 'mvn clean test'
      }
    }
    stage('Deploy Standalone') { 
      steps {
        sh 'mvn deploy -P standalone'
      }
    }
    stage('Deploy ARM') { 
      environment {
        ANYPOINT_CREDENTIALS = credentials('anypoint.credentials') 
      }
      steps {
        sh 'mvn deploy -P arm -Darm.target.name=local-3.9.0-ee -Danypoint.username=${ANYPOINT_CREDENTIALS_USR}  -Danypoint.password=${ANYPOINT_CREDENTIALS_PSW}' 
      }
    }
    stage('Deploy CloudHub') { 
      environment {
        ANYPOINT_CREDENTIALS = credentials('anypoint.credentials')
      }
      steps {
        sh 'mvn deploy -P cloudhub -Dmule.version=3.9.0 -Danypoint.username=${ANYPOINT_CREDENTIALS_USR} -Danypoint.password=${ANYPOINT_CREDENTIALS_PSW}' 
      }
    }
  }
}


 #
