# Continuous Integration (CI)

### What is it?

Continuous integration is the practice of frequently merging code changes.
But frequent merges cause difficulties:
- What if the code doesn't compile after a merge
- What if someone breaks something
It would be a lot of work to check these things on every merge.
The solution is to automate this process.

We use a CI server which executes a build that automatically prepares/compiles the code and runs automated tests.
Usually, the CI server automatically detects code changes in source control and run the build whenever there is a change.
If something is wrong, the build fails. The team can get immediate feedback if their change broke something. It can take in form of emails.
Merging frequently throughout the day and getting quick feedback means that if you broke something, you broke it with your changes within the last couple hours. This is much easier to identify/fix than if you broke something with your changes from a week ago! For that, we will be using Jenkins as our CI server.

### Setting up CI Infrastructure-As-Code

To set up Jenkins:
```console
sudo yum -y remove java
sudo yum -y install java-1.8.0-openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Go to the Jenkins web UI, your_server_address:8080 in a browser,
eg. http://10.211.55.4:8080/

On the home page, you got this message:
```console
Unlock Jenkins
To ensure Jenkins is securely set up by the administrator, a password has been written to the log (not sure where to find it?) and this file on the server:
/var/lib/jenkins/secrets/initialAdminPassword
Please copy the password from either location and paste it below.
```
Follow the instruction, with the default setting

You can use as administrator account:
Username: jenkins
password: jenkins

In the case, there is an error, type the url your_server_address:8080/restart
  

## Creating a Pipeline-As-A-Code Job in Jenkins

We are going to use Jenkins Pipeline as a code plugin to create our Jenkins job. The cool part of using this plugin is that our entire Jenkins job configuration can be created, updated and version controlled along with the rest of our source code. Along with that, we will be using the power of docker to set up our entire CI infrastructure out of thin air!

##### Let’s see what a “very” high-level view of our Continuous Integration (CI) Pipeline using Jenkins looks like:

![jenkins_docker_pipeline](https://code-maze.com/wp-content/uploads/2018/07/HighLevelFlow.png)

A jenkins pipeline is an automated process built on these tools. It takes source code through a "pipeline" from the source code creation all the way to production deployment.

Pipelines adhere to the best practice of infrastructure as code. Therefore, a pipeline is implemented in a file that is kept in source control along with the rest of the application code. This file is called a Jenkinsfile.
To create a pipeline, simply create a file called Jenkinsfile and add it to your source control repo.
When creating the Jenkins project, choose the "pipeline" or "Multibranch pipeline" project type.

Pipeline has a domain-specific-language(DSL) that is used to define the pipeline logic

##### Writing a Jenkins File

There are 2 styles of Pipeline syntax you can choose:
- either scripted - a bit more like procedural code
- either declarative - syntax describes the pipeline logic


Here is what our Jenkinsfile looks like:
```console
pipeline {
    agent any
    tools { 
        maven 'Maven 3.5.4'
        jdk 'java-1.8.0-openjdk'
    }
    stages{
        stage ('Build - Maven') {
            steps{
                echo "Building - Maven..."
                sh 'cd /apps/click-count && mvn package'
                
            }
        }
        stage ('Test'){
            steps{
                echo "Testing..."
                sh 'cd /apps/click-count && mvn package'

            }
        }
        stage('Build - Docker image'){
            steps{
                echo "Building - Docker image..."
                sh 'cd /apps && docker build --no-cache -t terryv8/web-app .'
            }
        }

        stage ('Deploy'){
            steps{
                echo 'Deploying...'
            }
        }
        stage ('End'){
            steps{
                //dir ('/var/lib/jenkins/workspace/pipeline-demo')
                echo 'End...'
            }
        }   
    }
}
```


Once you finished writing the Jenkinsfile, back to the main page of the project and click on "Build now"

![jenkins_docker_pipeline_build_now](https://code-maze.com/wp-content/uploads/2018/07/InProgress.png)

This is the output expected in the console:
```console

```


## LATER IMPROVEMENT: 
## Automatically triggering builds as soon as commit to git

For my project, I haven't set up the automatic triger yet.
Below I am going to give you the idea on how to configure it.

Some teams have a scheduled build that runs one a week, one a day, twice a day. However, the most efficient and immediate way is to have a trigger. We are going to use Webhooks which is event notifications made from one application to another over HTTP. In jenkins, we can use webhooks to have Github notify Jenkins as soon as the code in GitHub changes.
Jenkins can respond by automatically running the build to implement any changes. We can configure Jenkins to automatically create and manage webhooks in GitHub. So we must give jenkins access to an API token that allows accessing the GitHub API.

Configuring webhooks in Jenkins is relatively easy. We need to:
_ Create an access token in GitHub that has permission to read and create webhooks
_ Add a GitHub server in Jenkins for GitHub.com
_ Create a jenkins credential with the token and configure the GitHub server configuration to use it
_ Check "Manage Hooks" for the GitHub server configuration
_ In the project configuration, under "Build triggers", select "GitHub hook trigger for GITScm polling"

- #### On GitHub
click Settings >> Developer settings >> Personal access tokens >> Generate new token
Select the right permission: admin:repo_hook >> write:repo_hook and read:repo_hook

- #### On Jenkins
Click Manage Jenkins >> Configure system
In the section GitHub, select Git server, name: GitHub, Credentials: Add jenkins
Select Kind: Secret text, Secret: "Enter the api key of GitHub", ID: github_key, Description: GitHubKey
Then Credential: GitHubKey, check "Manage hooks", click on "test connection"

I've just set up my Jenkins server to be able to authenticate with GitHub.

Click on the project >> Configure. 
_ In the section "Source Code Management" >> Git >> Repository URL: https://github.com/TerryV8/cicd-pipeline-train-schedule-jenkins
_ In the section  "Build triggers", select "Github hook trigger for GITScm polling"




## What if you need to run Jenkins under a different user in Linux

To change the jenkins user, open the /etc/sysconfig/jenkins (in Debian, this file is created in /etc/default) and change the JENKINS_USER to whatever you want. Make sure that user exists in the system (you can check the user in the /etc/passwd file ).
```console
$JENKINS_USER="manula"
Then change the ownership of the Jenkins home, Jenkins webroot and logs.
chown -R manula:manula /var/lib/jenkins 
chown -R manula:manula /var/cache/jenkins
chown -R manula:manula /var/log/jenkins
Then restarted the Jenkins jenkins and check the user has changed using a ps command 
/etc/init.d/jenkins restart
ps -ef | grep jenkins
```
