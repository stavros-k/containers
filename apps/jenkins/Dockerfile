FROM jenkins/jenkins:2.433-jdk17@sha256:dca9fffe8c9be97f43e7d671b66f532bc42a99abc80b61233571d04838568859

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY "errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
