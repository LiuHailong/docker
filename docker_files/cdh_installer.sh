#!/bin/bash

# install jdk
rpm -ivh /tmp/jdk_install/jdk-7u80-linux-x64.rpm

# install mysql
rpm -e $(rpm -qa | grep mariadb)
rpm -ivh /tmp/MySQL-*.rpm
cp /tmp/mysql_install/my.cnf /etc/my.cnf
cp /tmp/mysql_install/mysql-connector-java-5.1.38.jar /usr/share/java/mysql-connector-java.jar

# init mysql
/usr/bin/mysql_install_db
service mysql restart
/usr/bin/mysqladmin -uroot -p password '123456'

GRANT_SQL="grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;flush privileges;"

SQL_ADD_DATABASES="create database metastore DEFAULT CHARACTER SET latin1;create database amon DEFAULT CHARACTER SET utf8;create database rmon DEFAULT CHARACTER SET utf8;create database sentry DEFAULT CHARACTER SET utf8;create database hue CHARACTER SET utf8;create database oozie CHARACTER SET utf8;"

/usr/bin/mysql -uroot -p123455 -e "$GRANT_SQL"
/usr/bin/mysql -uroot -p123456 -e "$SQL_ADD_DATABASES"

# install cdh
mkdir -p /opt/cloudera-manager
tar -axvf /tmp/cdh_install/cloudera-manager-el6-cm5.8.2_x86_64.tar.gz -C /opt/cloudera-manager
/usr/sbin/useradd  --system --home=/opt/cloudera-manager/cm-5.8.2/run/cloudera-scm-server --no-create-home --shell=/bin/false --comment "Cloudera SCM User" cloudera-scm
mkdir /var/cloudera-scm-server
chown cloudera-scm:cloudera-scm /var/cloudera-scm-server
chown cloudera-scm:cloudera-scm /opt/cloudera-manager

mkdir -p /opt/cloudera/parcel-repo
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo
cp /tmp/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel /opt/cloudera/parcel-repo
cp /tmp/cdh_install/CDH-5.8.2-1.cdh5.8.2.p0.3-el6.parcel.sha /opt/cloudera/parcel-repo
cp /tmp/cdh_install/manifest.json /opt/cloudera/parcel-repo

mkdir -p /opt/cloudera/parcels
chown cloudera-scm:cloudera-scm /opt/cloudera/parcels
/opt/cloudera-manager/cm-5.8.2/share/cmf/schema/scm_prepare_database.sh mysql -hcloudera -uroot -p123456 --scm-host cloudera scm scm scm

/opt/cloudera-manager/cm-5.8.2/etc/init.d/cloudera-scm-agent start
/opt/cloudera-manager/cm-5.8.2/etc/init.d/cloudera-scm-server start
