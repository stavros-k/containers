FROM jenkins/jenkins:2.489-jdk17@sha256:c4108b675b8a6204030760a9aef29f788303041f9693cf76dca9a373c5152cf4

ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY="errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
