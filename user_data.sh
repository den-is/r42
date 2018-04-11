#!/bin/bash
apt-get -y update
apt-get -y install git default-jdk maven
apt-get clean

echo "JAVA_HOME=$(/usr/bin/java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | tr -s ' ' | cut -d ' ' -f 4)" >> /etc/environment
source /etc/environment

cd /opt
git clone https://github.com/lc-nyovchev/opstest.git
cd /opt/opstest

mvn clean package

cat <<EOF > /etc/systemd/system/suchapp.service
[Unit]
Description=suchapp
Documentation=https://github.com/lc-nyovchev/opstest
Requires=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/java -jar /opt/opstest/target/suchapp-0.0.1-SNAPSHOT.jar --suchname="$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)"
RestartSec=10
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start suchapp
systemctl enable suchapp
