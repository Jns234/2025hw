#!/bin/bash
set -e

Help(){
    echo "This is the help command"
}

CheckFileExistance(){
    if [ ! -f $1 ]; then
        echo "File '$1' not found!"
        exit
    else
        echo "Log '$1' file found!"
    fi
}

CheckHostAvailable() {
    if ! ping -c1 -W1 $1 &> /dev/null; then
        echo "Remote host $1 is not reachable"
        exit
    else
        echo "Remote host $1 is reachable"
    fi

}

CheckHostPortAvailable() {
    if ! netcat -z -w5 $1 $2; then
        echo "Host $1 with port $2 not reachable"
        exit
    else
        echo "Host $1 with port $2 reachable"
    fi
}

while getopts ":hf:a:p:" option; do
   case $option in
      a) # The host where logs ar ebeing sent
         hostAddress=$OPTARG
         CheckHostAvailable $hostAddress
         ;;
      p) # The port of the host being checked
         hostPort=$OPTARG
         CheckHostPortAvailable $hostAddress $hostPort
         ;;
      f) # The input file
         FilePath=$OPTARG
         CheckFileExistance $FilePath
         ;;
      h) # display Help
         Help
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo "Hello world!" 