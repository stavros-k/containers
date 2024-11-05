FROM jenkins/jenkins:2.484-jdk17@sha256:c419b505a815bb2d2dcb2a3b04f5913f5e009fa808b77ac974cd2e93ee4eee11

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY "errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
