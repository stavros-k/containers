FROM jenkins/jenkins:2.494-jdk17@sha256:2168f33fc3fa4e25a72c51cb69fb783a2ee1273f518d6746c2666929c1bc36ca

ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY="errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
