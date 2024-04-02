FROM jenkins/jenkins:2.452-jdk17@sha256:f3440d7e65199b93addf7756f41341b2d2228f6d108e510e9107884953e6594b

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY "errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
