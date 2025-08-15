# The Log Reading Tool

## About the tool
The goal of this tool is to read logs from a given file and to send those logs to a host. The tool itself is a simple bash script. The tool is capable of sending logs through *udp* and *tcp*. The tool uses the ```logger``` command to send log messages to a remote host.


## Using the tool

In order to be able to use the tool, the script needs to be given execution rights:
```
chmod +x ./logTool.sh
```

Once the execution rights have been assigned, the programme needs to be used with the **log file** full path, **destination host** and **destination port**. An example looks like the following:
```
./logTool.sh -f /mnt/c/Users/Jan/Desktop/2025hw/shellTool/logs.log -a 192.168.1.7 -p 5140
```
![Image showing the Log Reading Tool output.](./../img/logTool.png)

### The options
With the ```-h``` flag (aka the help flag) the page showcasing how to use the tool and it's flags presents itself:
```
jan@DESKTOP-E1CJO7B:/mnt/c/Users/Jan/Desktop/2025hw/shellTool/RunningOnWSL$ ./logTool.sh -h
The script reads lines of logs of a given file, sending those either using tcp or udp with the possibility to exclude log lines just containing newline characters.

Syntax: ./logTool.sh [-a|p|P|e|f|h]
options:
a     The hostname or address of the host where the logs are send, Required.
p     The port of the hostname or address where the logs are send, Required.
P     The protocol being used to send the logs to the host, default: udp.
e     Send the logs without including lines that just contain newlines, default: false.
f     The log file containing logs being sent, Required
h     The help page!

```
### Running on WSL
Due to conflicting EOL when developing the script and running on WSL, the EOL needs to be changed LF from CRLF. Due to the way git behaves, every time it's commited it changes the EOL to CRLF.
