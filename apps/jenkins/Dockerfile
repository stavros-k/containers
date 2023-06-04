FROM jenkins/jenkins:2.401.1@sha256:d277e629f9e4d9308bdde5961eba88498fe4cba7af00091d56cb161a85472280

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY "errorOnConflict"

# COPY --chown=jenkins:jenkins jenkinsConfig/configs/ /var/jenkins_home/casc_configs/
COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml

# Skip initial setup
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
