# Exercise

## Context

### Needs

The french Startup Click Paradise has developed a click counter application and in a Lean approach
it wants to deliver the evolutions continuously.
You have joined the team as a DevOps profile and your first task is to industrialize
the construction and delivery of the "Click Count" application.


### Technical environment

The web application is developed in Java and uses Redis for storing data. The deployments
are always done first on a Staging environment and then, after validation, on the environment of
Production. Each environment relies on a separate instance of Redis (available to you
by Xebia for this exercise) accessible by its own IP address.

The application is built with Maven and a JDK 1.8 with the following command: mvn clean package
Deployment of the application can be done within any web container (Tomcat, Jetty, ...).
the choice is left to you) and requires a JVM version 1.8.

## Goal

You can modify the code of the application and use whatever seems relevant to you to fill
the objectives of the company, namely to deliver quickly and automatically the evolutions in
Production.

The infrastructure of the Staging and Production environments must be configured automatically
in order to ensure the sustainability of the solution. You have at your disposal:
• The sources of the application: https://github.com/xebia-france/click-count
• The ip addresses of the Redis instances of the Staging and Production environments: transmitted
in the mail containing this 'statement'

You are really free on the choice of technologies: the objective is to have a functional result.
In particular, you have the freedom to turn to the supplier of IaaS, PaaS or other of your choice, or
to replicate staging / production environments locally (using tools such as
Vagrant, Docker, etc.)!

The expected deliverable must be a repository on GitHub containing the description of the infrastructure
and the continuous delivery pipeline fully automated so that the solution can be deployed on a
different environment.
