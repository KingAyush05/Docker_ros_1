# Ayush
FROM osrf/ros:noetic-desktop-full

RUN apt-get update \
    && apt-get install -y vim \
    && rm -rf /var/lib/apt/lists* 

ARG USERNAME=kingayush
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# # Set the working directory inside the container
# WORKDIR /ros1_catkin_ws

# Set environment variables for ROS
ENV DEBIAN_FRONTEND=noninteractive
ENV TURTLEBOT3_MODEL=burger

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config && chown -R $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Update and install required packages
RUN apt-get update && apt-get install -y \ 
    ros-noetic-turtlebot3 \
    ros-noetic-turtlebot3-simulations \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    x11-apps

#Python3 installation
RUN apt-get update && apt-get install -y python3 python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install matplotlib pandas \
    && pip3 install pandas \
    && rm -rf /var/lib/apt/lists/*

#rosdep
RUN apt-get update && apt-get install -y python3-rosdep \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    python3-rosdep \
    python3-vcstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Add the ROS repository (if needed)
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s http://packages.ros.org/ros.key | apt-key add -

# Update apt package index
RUN apt-get update

# Initialize rosdep only if it's not already initialized
RUN if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
    rosdep init; \
    fi && \
    rosdep update

CMD ["bash" , "-c" , "source /opt/ros/noetic/setup.bash && bash"]
