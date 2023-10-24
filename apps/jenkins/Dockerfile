FROM jenkins/jenkins:2.429-jdk17@sha256:ea042d8f75dadddf3386456922a0868823164ab076e78ceef78e1593e8466247

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY "errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
