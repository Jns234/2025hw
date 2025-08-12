#!/bin/bash
set -e

Help(){
    echo "The script reads lines of logs of a given file, sending those either using tcp or udp with the possibility to exclude log lines just containing newline characters.

Syntax: ./logTool.sh [-a|p|P|e|f|h]
options:
a     The hostname or address of the host where the logs are send, Required.
p     The port of the hostname or address where the logs are send, Required.
P     The protocol being used to send the logs to the host, default: udp.
e     Send the logs without including lines that just contain newlines, default: false.
f     The log file containing logs being sent, Required
h     The help page!
"
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
    if ! netcat -u -z -w5 $1 $2 &> /dev/null && ! netcat -z -w5 $1 $2 &> /dev/null; then
        echo "Host $1 with port $2 not reachable"
        exit
    else
        echo "Host $1 with port $2 reachable"
    fi
}

SendLinesUDP(){
    logger -d -n $hostAddress -P $hostPort "$line"
}

SendLinesTCP(){
    logger -n $hostAddress -P $hostPort "$line"
}

COUNT=1
ReadLinesWithEmpty() {
    while IFS= read -r line || [ -n "$line" ]; do
        case $2 in
            udp) # Send the lines using udp
                SendLinesUDP "$line"
                ;;
            tcp) # Send the lines using tcp
                SendLinesTCP "$line"
                ;;
            \?) # Invalid option
                echo "Error: Invalid option"
                exit;;
        esac
        echo "$COUNT lines sent"
        ((COUNT++))
    done < "$1"
}

ReadLinesNonEmpty() {
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ $line == $'\r' ]]; then
            #echo "Empty line found $line"
            continue
        fi
        case $2 in
            udp) # Send the lines using udp
                SendLinesUDP "$line"
                ;;
            tcp) # Send the lines using tcp
                SendLinesTCP "$line"
                ;;
            \?) # Invalid option
                echo "Error: Invalid option"
                exit;;
        esac
        echo "$COUNT lines sent"
        ((COUNT++))
    done < "$1"
}


while getopts ":hf:a:p:P:e" option; do
   case $option in
      a) # The host where logs ar ebeing sent
         hostAddress=$OPTARG
         CheckHostAvailable $hostAddress
         ;;
      e) # Send the logs with no lines starting with newlines
         NoEmtpy=true
         ;;
      p) # The port of the host being checked
         hostPort=$OPTARG
         CheckHostPortAvailable $hostAddress $hostPort
         ;;
      f) # The input file
         FilePath=$OPTARG
         CheckFileExistance $FilePath
         ;;
      P) # Choose the protocol
         Protocol=${OPTARG,,}
         ;;
      h) # display Help
         Help
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Help
         exit;;
   esac
done

if ! ((${#hostAddress[@]})) || ! ((${#hostPort[@]})) || ! ((${#FilePath[@]})); then
    echo "Some flag is missing, -a host address, -p host port and -f file flags are mandatory, use the -h flag to find out more!"
    exit
elif ! ((${#Protocol[@]})) || [ "$Protocol" = "udp" ]; then
    echo "Sending as default, udp."
    case $NoEmtpy in
        true) # Send the logs without lines starting in newlines
             ReadLinesNonEmpty $FilePath udp
             ;;
          *) # Send the logs as is
             ReadLinesWithEmpty $FilePath udp
             ;;
    esac
elif [ "$Protocol" = "tcp" ]; then
    echo "Sending with tcp."
    case $NoEmtpy in
        true) # Send the logs without lines starting in newlines
             ReadLinesNonEmpty $FilePath tcp
             ;;
          *) # Send the logs as is
             ReadLinesWithEmpty $FilePath tcp
             ;;
    esac
fi
