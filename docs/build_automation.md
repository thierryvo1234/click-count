# Build Automation

Build Automation is the automation of the tasks required to process and prepare the source code for deployment in production. It is an important component of continuous integration.

This includes:
- the compilation
- the dependency management: If there are third parties or libraries that need to be present to compile, or test the code, they will be included in the same package.
- the execution of automation tests: It makes sure that tests are executed and if they fail, it makes fail the build
- the packaging of the application for deployment

I used Maven as a build automation tool.

Let's install Gradle:
```bash
cd ~/
wget -O ~/gradle-4.7-bin.zip https://services.gradle.org/distributions/gradles-4.7-bin.zip
sudo yum -y install unzip java-1.8.0-openjdk
sudo mkdir /opt/gradle
sudo unzip -f /opt/gradle ~/gradle-4.7-bin.zip
sudo vi /etc/profile.d/gradle.sh
```

Put the text in the gradle.sh:
```bash
export PATH=$PATH:/opt/gradle/gradle-4.7/bin
```

Then, put the permissions on gradle.sh:
```bash
sudo chmod 755 /etc/profile.d/gradle.sh
```

After being connected and reconnected:
```bash
gradle --version
```

Finally, to install and launch the Gradle wrapper:
```bash
cd ~/
mkdir my-project
cd my-project
gradle wrapper
./gradlew build
```

Gradle builds are made of a set of tasks.
When you launch "gradle build", it calls a set of tasks that you want to execute:
```bash
./gradlew sayHello
```


To running the app, let's begin by installing the npm dependencies with:
```console
npm install
```
Then, you can run the app with:

```console
npm start
```
Once it is running, you can access it in a browser at http://localhost:3000


## Automated testing
- Automated testing is the automated execution of tests that verify the quality and stability of the code
- Automated tests are usually coded themselves, so they are code that is written to test other code
- Automated tests are often run as part of the build process and are executed using build tools like maven.

There are multiple types of automated tests:
- Unit Tests focus on testing small pieces of code in isolation. Usually a single method or function
- Integrations Tests tests larger portions of an application that are integrated with each other
- Smoke test / Sanity tests - these are high-level integration tests that verify basic, large-scale things like whether or not the application runs, whether application endpoints return HTTP 500 errors, etc


```console
Index page
GET / 200 23.23.ms
  renders successfully
  
Trains API
GET /trains 200 4.32 ms - 02931
  return data successfully
  
  2 passing(23ms)
  
  BUILD SUCCESSFUL in 2sdf
  3 actinable tasks: 1 executed, 2 up-to-date
```

What Maven does?
- Compilation of Source Code
- Running Tests (unit tests and functional tests)
- Packaging the results into JAR’s, WAR’s, RPM’s, etc ...
- Upload the packages to remote repo’s (Nexus, Artifactory)
