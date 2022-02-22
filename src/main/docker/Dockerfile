# extract internal and external dependencies
FROM crm-nexus.itg.echonet/bp2i-images/openjdk11:0.6-1 as build

ARG PUID=1024
ARG PGID=1024
ARG ARTIFACT=@rootDockerdir@target/v360-api-fat.jar

#1066.16. Dockerfile WORKDIR
WORKDIR /workspace/app

USER 0

COPY $ARTIFACT application.jar

# extract layer image
RUN mkdir -p ./dependency && $JAVA_HOME/bin/java -Djarmode=layertools -jar application.jar extract --destination dependency

# ----------------------------------------------------

FROM crm-nexus.itg.echonet/bp2i-images/openjdk11:0.6-1
ENV SPRING_CONFIG_ADDITIONAL_LOCATION /applis/config/

# ARTIFACT, GITBRANCH et GITCOMMIT seront surchargés au moment du build
# Laisser ces valeurs par défaut
ARG GITBRANCH=master
ARG GITCOMMIT=0000000
ARG DEPENDENCY=/workspace/app/dependency
ARG PUID=1024
ARG PGID=1024
ARG ENTRYPOINTSH=@rootDockerdir@entrypoint.sh
ARG EXPOSEDPORT=8080


#1083.47.   Labels for Docker image (mandatory)
LABEL maintainer=mlist_paris_itg_rdb_zephyr@bnpparibas.com
LABEL description="v360-api application"

#1083.48.   Labels for Docker image (Best practice)
LABEL codetype=java
LABEL gitbranch=$GITBRANCH
LABEL gitcommit=$GITCOMMIT
LABEL component=poc_mongo

#root
USER 0

#1066.16.   “Dockerfile” WORKDIR
WORKDIR /applis

#folder
RUN mkdir -p ./config ./tmp ./security ./app

#1066.15. DockerFile USER
RUN groupadd -g $PGID app-group && useradd -u $PUID -g $PGID -c "add app user" -M app

# copy layers of dependencies from layers of fat jar in app/lib 
## external release jar
COPY --from=build ${DEPENDENCY}/dependencies ./app
## company's release jar 
COPY --from=build ${DEPENDENCY}/company-dependencies ./app
## internal release jar (domain, infra)
COPY --from=build ${DEPENDENCY}/internal-dependencies ./app
## snapshot jar
COPY --from=build ${DEPENDENCY}/snapshot-dependencies ./app
## copy spring-boot-loader layer
COPY --from=build ${DEPENDENCY}/spring-boot-loader ./app
## copy application layer
COPY --from=build ${DEPENDENCY}/application ./app

# copy entrypoint
COPY ${ENTRYPOINTSH} ./entrypoint.sh

COPY @rootDockerdir@certificat.crt certificat.crt
RUN chmod +x entrypoint.sh
RUN $JAVA_HOME/bin/keytool -cacerts -import -alias mongodbcertificat -file /applis/certificat.crt -storepass changeit -noprompt

# update owner of directories and sudirectories /applis to $PUID:$PGID
RUN chown -R $PUID:$PGID .

# update rights on directories
RUN chmod -R ug+rwx . && chmod -R ug+rx ./entrypoint.sh && chmod -R ug+rx ./app && chmod -R ug+rwx ./tmp && chmod -R ug+rx ./config && chmod -R ug+rx ./security

#1066.15. DockerFile USER
USER $PUID

# VOLUMES : declare volumes after chown and after USER app
VOLUME /applis/config
VOLUME /applis/tmp
VOLUME /applis/security

ENV JAVA_OPTS=""

#1066.17. Dockerfile EXPOSE
EXPOSE ${EXPOSEDPORT}

ENTRYPOINT ["./entrypoint.sh"]

