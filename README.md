# Random Generator Application Demonstrating usage of Eclipse JKube for deploying onto Kubernetes

## How to build
Just run `mvn clean install`

## How to run
Do `mvn spring-boot:run`

## Deploying on Kubernetes

### Building Docker image
> mvn k8s:build

### Generating Kubernetes Manifests

In order to deploy these generated manifests onto Kubernetes, just issue:

> mvn k8s:resource

This would generate Kubernetes manifests which would be available in target/ directory, as shown in listing below:
>$ tree target/classes/META-INF/jkube/

### Deploying application onto Kubernetes

In order to deploy these generated manifests onto Kubernetes, just issue:

> mvn k8s:apply or mvn k8s:deploy

### CleanUp: Un-deploy your application from Kubernetes cluster

If you want to un-deploy, we have this goal to delete all resources applied.

> mvn k8s:undeploy

## k8s:watch

This goal is used to monitor the project workspace for changes and automatically trigger a redeploy of the application running on Kubernetes. There are two kinds of watchers present at the moment:

- Docker Image Watcher(watches docker images)

- Spring Boot Watcher(based on Spring Boot Devtools)

For any application having resource and build goals bound to the lifecycle, the following command can be used to run the watch task.

> mvn k8s:watch

Once the goal starts up the spring boot RemoteSpringApplication it will watch for local development changes.

e.g. if you edit the java code of your app and then build it via something like this:

> mvn package


# Si vous ajoutez le répertoire raw, le watch ne pourra pas marcher :
> An error has occurred while while trying to watch the resources: Multiple selectors found for the given entities:
