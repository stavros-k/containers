FROM jenkins/jenkins:2.580-jdk25@sha256:98ecd14a50bd6e530f4d9f718ce2564fbc3179267c122ba11d6f8dd4b362123a

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
