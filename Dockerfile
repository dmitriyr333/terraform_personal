FROM golang:1.9

RUN apt-get update && apt-get install -y zip 

# terraform
WORKDIR /tmp
RUN wget https://releases.hashicorp.com/terraform/0.10.0/terraform_0.10.0_linux_amd64.zip
RUN unzip terraform_0.10.0_linux_amd64.zip -d /usr/local/bin

# ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip 
RUN unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin


# atlantis
RUN git clone https://github.com/hootsuite/atlantis.git /opt/atlantis
WORKDIR /opt/atlantis

RUN go-wrapper download   # "go get -d -v ./..."
RUN make build-service


EXPOSE 4141

# CMD ['./atlantis', 'server']