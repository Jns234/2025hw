# Syslog Server

## How to create an image
In order to run the the Rsyslog server container, a local image must be built using the **Dockerfile**.
Either navigate to the folder or provide the path to the **Dockerfile** and use the ```docker build``` command:
```
sudo docker build -t rsyslogserver .
```
This will build the docker image and make it accessable using the **rsyslogserver** tag.

## How to run the Docker image
Once the necessary Docker image had been created, the rsyslog server can be started using the ```docker run``` command:
```
sudo docker run --name rsyslog -d -p 514:514/udp docker.io/library/rsyslogserver
```

This will run a detached container which is named rsyslog using the created Docker image and map both external and internal ip's to 514 using udp.