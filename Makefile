TAG=2.4.8-hadoop2.7
SPARK_VERSION=2.4.8
SCALA_VERSION=2.11.12
HADOOP_TAG=2.0.0-hadoop2.7.4-java8

build:
	sh build.sh

start:
	SPARK_TAG=${TAG} docker compose up spark-master spark-worker

run:
	SPARK_TAG=${TAG} docker compose run --rm -p 4040:4040 spark-submit

stop:
	SPARK_TAG=${TAG} docker compose down

start-spark-yarn:
	HADOOP_TAG=${HADOOP_TAG} SPARK_TAG=${TAG} docker compose -f docker-compose-yarn.yml up namenode datanode resourcemanager nodemanager historyserver

run-spark-yarn:
	HADOOP_TAG=${HADOOP_TAG} SPARK_TAG=${TAG} docker compose -f docker-compose-yarn.yml run --rm -p 4040:4040 -w /spark spark-yarn-submit	

stop-spark-yarn:
	HADOOP_TAG=${HADOOP_TAG} SPARK_TAG=${TAG} docker compose -f docker-compose-yarn.yml down