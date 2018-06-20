FROM centos:6.9
MAINTAINER liuhailong@odianyun.com

# 设置当前工具目录
# 该命令不会新增镜像层
# WORKDIR /root/docker/cdh_docker_build

# 安装必要的工具
RUN yum -y install openssh-server && yum -y install openssh-clients && yum -y install initscript && yum -y install net-tools && yum -y install lsof && yum -y install python-lxml && yum -y install libaio

RUN mkdir -p /tmp/mysql_install && mkdir -p /tmp/cdh_install && mkdir -p /tmp/jdk_install
# mysql_install
ADD docker_files/mysql_install/MySQL-client-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-client-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-devel-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-devel-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-embedded-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-embedded-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-server-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-server-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-shared-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-shared-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-shared-compat-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-shared-compat-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/MySQL-test-5.6.26-1.linux_glibc2.5.x86_64.rpm /tmp/mysql_install/MySQL-test-5.6.26-1.linux_glibc2.5.x86_64.rpm
ADD docker_files/mysql_install/mysql-connector-java-5.1.38.jar /tmp/mysql_install/mysql-connector-java-5.1.38.jar
ADD docker_files/my.cnf /tmp/mysql_install/my.cnf

# cdh_install
ADD docker_files/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel /tmp/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel
ADD docker_files/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel.sha /tmp/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel.sha
ADD docker_files/cdh_install/cloudera-manager-el6-cm5.8.2_x86_64.tar.gz /tmp/cdh_install/cloudera-manager-el6-cm5.8.2_x86_64.tar.gz
ADD docker_files/cdh_install/manifest.json /tmp/cdh_install/manifest.json

# jdk_install
ADD docker_files/jdk_install/jdk-7u80-linux-x64.rpm /tmp/jdk_install/jdk-7u80-linux-x64.rpm

ADD docker_files/cdh_installer.sh /tmp/cdh_installer.sh
RUN \
    chmod +x /tmp/cdh_installer.sh && \
    /bin/bash /tmp/cdh_installer.sh

# cloudera hadoop ports mapping
EXPOSE 2181:2181
EXPOSE 8020:8020
EXPOSE 8888:8888
EXPOSE 11000:11000
EXPOSE 11443:11443
EXPOSE 9090:9090
EXPOSE 8088:8088
EXPOSE 19888:19888
EXPOSE 9092:9092
EXPOSE 8983:8983
EXPOSE 16000:16000
EXPOSE 16001:16001
EXPOSE 42222:22
EXPOSE 8042:8042
EXPOSE 60010:60010

# For Spark
EXPOSE 8080:8080
EXPOSE 7077:7077
