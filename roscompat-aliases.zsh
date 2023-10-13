# ROS2 --> ROS-style bindings
# Only link aliases if a version of ROS is not installed
# (i.e. calling "ros" fails)
# if [[ -e "ros" ]]; then
  alias rosnode="ros2 node"
  alias rosrun="ros2 run"
  alias rostopic="ros2 topic"
  alias rosservice="ros2 service"
  alias rosparam="ros2 param"
  alias rosbag="ros2 bag"
  alias ros2-autocomplete-patch="complete -o nospace -o default -F _python_argcomplete 'ros2'"
# fi
