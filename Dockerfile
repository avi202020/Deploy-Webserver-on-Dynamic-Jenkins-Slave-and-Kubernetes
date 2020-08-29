FROM centos:latest

RUN yum install wget -y
RUN yum install sudo -y
RUN yum install git -y
RUN yum install curl -y

#Installing kubernetes on the docker image
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin

#Copying the required files and certificates for running the kubernetes
RUN mkdir /root/jenkins
RUN mkdir /root/.kube
COPY client.key /root
COPY client.crt /root
COPY ca.crt /root
COPY config /root/.kube/config
COPY deploy.yml /root/

#Installing the required softwares for configuring Dynamic cluster in jenkins
RUN yum install java-1.8.0-openjdk.x86_64  -y
RUN yum install openssh-server -y
RUN echo "root:root" | chpasswd
RUN ssh-keygen -A
CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22
