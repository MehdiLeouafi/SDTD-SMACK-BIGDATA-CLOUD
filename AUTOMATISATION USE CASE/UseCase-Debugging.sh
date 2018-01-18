#!/bin/bash

#I-- The extraction of the set of Ip addresses, each represents a machine on which is installed a specific service

#2 Kafka IP 
cmd_kafka=`grep -n "kafka" hosts | cut -d : -f1`
KAFKA1=$(head -n $((cmd_kafka+1)) hosts | tail -n 1)
KAFKA2=$(head -n $((cmd_kafka+2)) hosts | tail -n 1)


#Zookeeper IP
cmd_zk=`grep -n "zookeeper" hosts | cut -d : -f1`
ZK1=$(head -n $((cmd_zk+1)) hosts | tail -n 1)

#Producer IP
cmd_prod=`grep -n "producer" hosts | cut -d : -f1`
PRODUCER=$(head -n $((cmd_prod+1)) hosts | tail -n 1)

#Mesos Master IP
cmd_prod=`grep -n "mesos_slave" hosts | cut -d : -f1`
MESOS_MASTER=$(head -n $((cmd_prod+1)) hosts | tail -n 1)

#Cassandra IP
cmd_Cassandra=`grep -n "cassandra" hosts | cut -d : -f1`
CASSANDRA=$(head -n $((cmd_prod+1)) hosts | tail -n 1)

#II-- Set all the parameters

# PARAMS OF TOPIC CREATION 
TOPIC_NAME="NV_TOPIC"
REP_FACTOR="1"

# PARAMS OF PRODUCER JOB
LIEN_JOB_PRODUCER="https://docs.google.com/uc?export=download&id=1QO4hABoVMplr_IKkZA87BesDWcRdRCdy"
BORNE_MINIMAL="0"
BORNE_MAXIMAL="25"
SPEED="2"

# PARAMS OF CONSUMER 
LIEN_JOB_CONSUMER="https://docs.google.com/uc?export=download&id=1R56-3o1JJk2tlMgxGVHR-9vYZSZmgjkw"
className="RddStatistique"



#III--The creation of the Topic on one or more Kafka broker, while specifying a set of parameters (Zookeper IP, the factor of replication, the name of the Topic)

ssh -i cluster_interconnection_cle ubuntu@$KAFKA1 /home/ubuntu/kafka/kafka_2.11-1.0.0/bin/kafka-topics.sh --create --replication-factor $REP_FACTOR --partitions 1 --zookeeper $ZK1:2181 --topic $TOPIC_NAME
cmd_create_topic="ssh -i cluster_interconnection_cle ubuntu@$KAFKA1 /home/ubuntu/kafka/kafka_2.11-1.0.0/bin/kafka-topics.sh --create --replication-factor $REP_FACTOR --partitions 1 --zookeeper $ZK1:2181 --topic $TOPIC_NAME"
echo "CREATE TOPIC:  $cmd_create_topic "



#IV-- Launch of JOB PRODUCER on a machine that has the role producer 

cmd_get_producer="wget '$LIEN_JOB_PRODUCER' -O Producer_Crypto.tar.gz"
NOM_JOB_PRODUCER="Producer_Crypto.jar"


#---------------------------------- PRODUCER WITHIOUT MESOS 

#WGET JOB ON PRODUCER
ssh -i cluster_interconnection_cle ubuntu@$PRODUCER $cmd_get_producer
ssh -i cluster_interconnection_cle ubuntu@$PRODUCER tar -xvzf Producer_Crypto.tar.gz
echo  "Extracting JAR ..."

#wget_producer="ssh -i cluster_interconnection_cle ubuntu@$PRODUCER $cmd_get_producer"
#unzip_producer="ssh -i cluster_interconnection_cle ubuntu@$PRODUCER tar -xvzf Producer_Crypto.tar.gz"
#echo  "wget_producer $wget_producer "

#EXECUTE JOB ON PRODUCER
ssh -i cluster_interconnection_cle ubuntu@$PRODUCER java -jar $NOM_JOB_PRODUCER --broker:$KAFKA1:9092 --topic:$TOPIC_NAME --BORNE_MINIMAL:$BORNE_MINIMAL --BORNE_MAXIMAL:$BORNE_MAXIMAL --speed:$SPEED &
cmd_producer="ssh -i cluster_interconnection_cle ubuntu@$PRODUCER java -jar $NOM_JOB_PRODUCER --broker:$KAFKA1:9092 --topic:$TOPIC_NAME --BORNE_MINIMAL:$BORNE_MINIMAL --BORNE_MAXIMAL:$BORNE_MAXIMAL --speed:$SPEED &"
echo " PRODUCER : $cmd_producer "


#---------------------------------- PRODUCER WITH MESOS
cmd_send="scp -i cluster_interconnection_cle -o StrictHostKeyChecking=no $NOM_JOB_PRODUCER ubuntu@$MESOS_MASTER:~/"
#echo " SEND PRODUCER JAR TO MESOS: $cmd_send "

cmd_producer_mesos="ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER mesos-execute --master=$MESOS_MASTER:5050 --name=\"test-exec\" --command=\"java -jar $NOM_JOB --broker:$KAFKA1:9092 --topic:$TOPIC_NAME --BORNE_MINIMAL:$BORNE_MINIMAL --BORNE_MAXIMAL:$BORNE_MAXIMAL --speed:$SPEED\"" 
#echo " MESOS PRODUCER : $cmd_producer_mesos"

# V-Launching the JOB Consumer on a machine running the Spark Driver service

cmd_get_consumer="wget '$LIEN_JOB_CONSUMER' -O RDD_Crypto.tar"
NOM_JOB_CONSUMER="RDD_Crypto.jar"


# ------------  WGET JOB ON CONSUMER ( MESOS )
#wget_consumer="ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER $cmd_get_consumer"
#unzip_consumer="ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER tar RDD_Crypto.tar"
#echo  "wget_consumer $wget_consumer "

#ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER $cmd_get_consumer
#ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER tar RDD_Crypto.tar

#-------------- Send JOB to Mesos Master 

#cmd_send_conso="scp -i cluster_interconnection_cle -o StrictHostKeyChecking=no $NOM_JOB_CONSUMER ubuntu@$MESOS_MASTER:~/"
#echo " SEND CONSUMER JAR : $cmd_send_conso "

scp -i cluster_interconnection_cle -o StrictHostKeyChecking=no $NOM_JOB_CONSUMER ubuntu@$MESOS_MASTER:~/



#Execute Job COnsumer With Spark
ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER /home/ubuntu/spark-2.2.1-bin-hadoop2.7/bin/spark-submit --class \"$className\" --master local[4] $NOM_JOB_CONSUMER $KAFKA1:9092 $TOPIC_NAME $CASSANDRA &

#cmd_spark_mesos="ssh -i cluster_interconnection_cle ubuntu@$MESOS_MASTER /home/ubuntu/spark-2.2.1-bin-hadoop2.7/bin/spark-submit --class \"$className\" --master local[4] $NOM_JOB_CONSUMER $KAFKA1 $TOPIC_NAME $CASSANDRA &"
#echo "CONSUMER SPARK : $cmd_spark_mesos"



