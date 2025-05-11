FROM jenkins/jenkins:lts-jdk11

USER root

RUN apt-get update && \
    apt-get install -y maven docker.io && \
    usermod -aG docker jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Копируем YAML в правильное место
COPY casc_configs/jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

# Эта переменная указывает на файл, который будет скопирован Jenkins-ом в /var/jenkins_home/
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml

USER jenkins
