FROM jenkins/jenkins:2.546-jdk25@sha256:7c07f7fdba0d9f1f57ecefa0ce5253ca1d2a1011086f6152338eec6ff8c89f89

ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs"
ENV CASC_MERGE_STRATEGY="errorOnConflict"

COPY --chown=jenkins:jenkins ./plugins.yaml /usr/share/jenkins/ref/plugins.yaml

# Test connection
RUN curl https://ftp-chi.osuosl.org

# Update center https://updates.jenkins.io/
ENV JENKINS_UC="https://updates.jenkins.io/update-center.json"

# Install plugins
RUN jenkins-plugin-cli --clean-download-directory
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Skip initial setup
RUN echo $JENKINS_VERSION > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
