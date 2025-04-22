FROM jenkins/jenkins:2.507-jdk17@sha256:1544693cf9c839974c309fa590ea27057a88c4959a12beefcb7d627ee4792630

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
