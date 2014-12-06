#!/bin/bash

if [[ $BUILD_HADOOP_DONE && ${BUILD_HADOOP_DONE-_} ]]
   then
      echo "Skipping hadoop installation - already done"
   else
      curwd=`pwd`

      cd /tmp

      ## Add Cloudera repositories
      wget -c http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb
      sudo dpkg -i cdh5-repository_1.0_all.deb
      curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -

      ## Install Java
      sudo apt-get update -q -q
      sudo apt-get install -y openjdk-7-jdk
      export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

      ## Install Hadoop with YARN
      sudo apt-get install -y hadoop-conf-pseudo
      sudo dpkg -L hadoop-conf-pseudo
      sudo -u hdfs hdfs namenode -format
      for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done

      sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
      sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
      sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
      sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
      sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

      sudo service hadoop-yarn-resourcemanager start
      sudo service hadoop-yarn-nodemanager start
      sudo service hadoop-mapreduce-historyserver start

      sudo -u hdfs hadoop fs -mkdir /user
      sudo -u hdfs hadoop fs -chown $TESSERA_USER /user
      sudo -u hdfs hadoop fs -mkdir /user/$TESSERA_USER
      sudo -u hdfs hadoop fs -chown $TESSERA_USER /user/$TESSERA_USER
      rm cdh5-repository*

      ###########

      sudo touch /home/$TESSERA_USER/.Renviron
      echo 'HADOOP=/usr/lib/hadoop' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'HADOOP_HOME=/usr/lib/hadoop' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'HADOOP_CONF_DIR=/etc/hadoop/conf' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'HADOOP_BIN=$HADOOP_HOME/bin' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'HADOOP_OPTS=-Djava.awt.headless=true' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'HADOOP_LIBS=/etc/hadoop/conf:/usr/lib/hadoop/lib/:/usr/lib/hadoop/.//:/usr/lib/hadoop-hdfs/./:/usr/lib/hadoop-hdfs/lib/:/usr/lib/hadoop-hdfs/.//:/usr/lib/hadoop-yarn/lib/:/usr/lib/hadoop-yarn/.//:/usr/lib/hadoop-mapreduce/lib/:/usr/lib/hadoop-mapreduce/.//' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo "RHIPE_RUNNER=/home/${TESSERA_USER}/rhRunner.sh" | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo 'JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' | sudo tee -a /home/$TESSERA_USER/.Renviron
      echo export 'HADOOP=/usr/lib/hadoop' | sudo tee -a /etc/profile
      echo export 'HADOOP_HOME=/usr/lib/hadoop' | sudo tee -a /etc/profile
      echo export 'HADOOP_CONF_DIR=/etc/hadoop/conf' | sudo tee -a /etc/profile
      echo export 'HADOOP_BIN=$HADOOP_HOME/bin' | sudo tee -a /etc/profile
      echo export 'HADOOP_OPTS=-Djava.awt.headless=true' | sudo tee -a /etc/profile
      echo export 'HADOOP_LIBS=/etc/hadoop/conf:/usr/lib/hadoop/lib/:/usr/lib/hadoop/.//:/usr/lib/hadoop-hdfs/./:/usr/lib/hadoop-hdfs/lib/:/usr/lib/hadoop-hdfs/.//:/usr/lib/hadoop-yarn/lib/:/usr/lib/hadoop-yarn/.//:/usr/lib/hadoop-mapreduce/lib/:/usr/lib/hadoop-mapreduce/.//' | sudo tee -a /etc/profile
      echo export 'LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' | sudo tee -a /etc/profile
      echo export "RHIPE_RUNNER=/home/${TESSERA_USER}/rhRunner.sh" | sudo tee -a /etc/profile
      echo export 'JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64' | sudo tee -a /etc/profile

      sudo chown -R $TESSERA_USER:$TESSERA_USER /home/$TESSERA_USER

      echo '/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server/' | sudo tee -a  /etc/ld.so.conf.d/jre.conf
      echo '/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/' | sudo tee -a /etc/ld.so.conf.d/jre.conf
      echo '/usr/lib/hadoop/lib' | sudo tee -a  /etc/ld.so.conf.d/hadoop.conf

      cd $curwd

      export $BUILD_HADOOP_DONE=1
fi



