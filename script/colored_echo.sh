txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 5)
txtrst=$(tput sgr0) 

colored_echo() {
  color=$1
  msg=$2
  echo "${color}${msg}${txtrst}"
}

