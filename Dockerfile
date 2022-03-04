# Start from the code-server Debian base image
FROM codercom/code-server:3.10.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -------------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension vscode-icons-team.vscode-icons
RUN code-server --install-extension zhuangtongfa.material-theme

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make
RUN sudo apt-get update && \
    sudo apt-get install -y openjdk-11-jdk ca-certificates-java && \
    sudo apt-get clean && \
    sudo update-ca-certificates -f
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME
CMD ["java", "-version"]

#install wget
RUN  sudo apt-get update \
  && sudo apt-get install -y wget \
  && sudo rm -rf /var/lib/apt/lists/*
  
  
# Install x11vnc.
#RUN sudo apt-get install -y x11vnc
# Install xvfb.
#RUN sudo apt-get install -y xvfb
# Install fluxbox.
#RUN sudo apt-get install -y fluxbox
# Install wmctrl.
#RUN sudo apt-get install -y wmctrl
# Set the Chrome repo.
#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
# Install Chrome.
#RUN sudo apt-get update && apt-get -y install google-chrome-stable

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool


# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
