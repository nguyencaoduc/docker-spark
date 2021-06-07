ARG HADOOP_TAG
FROM hadoop-base:${HADOOP_TAG}

ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init

ARG SPARK_VERSION=2.4.8
ENV SPARK_VERSION=${SPARK_VERSION}
ENV SPARK_HADOOP_VERSION=2.7

COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /

#COPY bde-spark.css /css/org/apache/spark/ui/static/timeline-view.css

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl wget bash python3 jq \
    && ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 \
    && chmod +x *.sh \
    && wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} spark \
    && rm spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz \
    #&& cd /css \
    #&& jar uf /spark/jars/spark-core_2.11-${SPARK_VERSION}.jar org/apache/spark/ui/static/timeline-view.css \
    && cd /

ENV SPARK_HOME=/spark
COPY spark-env.sh /spark/conf
RUN chmod a+x /spark/conf/spark-env.sh
COPY conf/core-site.xml /etc/hadoop
COPY conf/hdfs-site.xml /etc/hadoop
COPY conf/yarn-site.xml /etc/hadoop

# Fix library error
RUN cp /opt/hadoop-${HADOOP_VERSION}/share/hadoop/yarn/lib/jersey-core-1.9.jar /spark/jars/
RUN cp /opt/hadoop-${HADOOP_VERSION}/share/hadoop/yarn/lib/jersey-client-1.9.jar /spark/jars/

ARG SCALA_VERSION=2.11.12
ARG SBT_VERSION=1.5.3
ENV SCALA_VERSION=${SCALA_VERSION} \
    SCALA_HOME=/usr/share/scala \
    SBT_VERSION=${SBT_VERSION}

RUN cd "/tmp" && \
    wget --no-verbose "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates wget tar && mkdir -p "/usr/local/sbt" && wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar xz -C /usr/local/sbt --strip-components=1

ENV PATH /usr/local/sbt/bin:$PATH

#Give permission to execute scripts
RUN chmod +x /wait-for-step.sh && chmod +x /execute-step.sh && chmod +x /finish-step.sh

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1
ENV YARN_CONF_DIR /etc/hadoop

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]