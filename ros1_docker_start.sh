#!/bin/bash

docker run -it --name ros1_cont --user kingayush --network=host --ipc=host --device=/dev/dri:/dev/dri -v /home/kingayush/sc649/ros1_catkin_ws:/ros1_catkin_ws -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/dri -e DISPLAY=$DISPLAY --group-add video --env=DISPLAY ros1_image
