FROM jenkins/jenkins:2.491-jdk17@sha256:4f00e34d725dbf10c57f1f78f1bd7d691c64bb467855e856751605fe51f80923

ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY="errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
