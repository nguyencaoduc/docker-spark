#!/bin/bash

set -e

TAG=3.0.2-hadoop2.7
SPARK_VERSION=3.0.2
SCALA_VERSION=2.12.12
HADOOP_TAG=2.0.0-hadoop2.7.4-java8

build() {
    NAME=$1
    IMAGE=spark-$NAME:$TAG
    cd $([ -z "$2" ] && echo "./$NAME" || echo "$2")
    echo '--------------------------' building $IMAGE in $(pwd)
    docker build -t $IMAGE --build-arg HADOOP_TAG=$HADOOP_TAG --build-arg TAG=$TAG --build-arg SPARK_VERSION=$SPARK_VERSION --build-arg SCALA_VERSION=$SCALA_VERSION .
    cd -
}

build base
build master
build worker
build submit
build java-template template/java
build scala-template template/scala
build python-template template/python
