FROM combustml/mleap-spring-boot:0.21.0-SNAPSHOT

RUN apt update && apt install -y wget libgomp1
RUN apt-get install ca-certificates
RUN wget https://repo1.maven.org/maven2/ml/combust/mleap/mleap-xgboost-runtime_2.12/0.21.0/mleap-xgboost-runtime_2.12-0.21.0.jar

RUN wget https://repo1.maven.org/maven2/ml/dmlc/xgboost4j_2.12/1.7.3/xgboost4j_2.12-1.7.3.jar
RUN wget https://repo1.maven.org/maven2/com/esotericsoftware/kryo/5.4.0/kryo-5.4.0.jar

RUN cp mleap-xgboost-runtime_2.12-0.21.0.jar /opt/docker/lib/ml.combust.mleap.mleap-xgboost-runtime-0.21.0-SNAPSHOT.jar
RUN cp xgboost4j_2.12-1.7.3.jar /opt/docker/lib/ml.dmlc.xgboost4j-1.7.3.jar
RUN cp kryo-5.4.0.jar /opt/docker/lib/com.esotericsoftware.kryo-5.4.0.jar

HEALTHCHECK CMD curl --fail http://localhost:8090/models || exit 1
COPY mleap-spring-boot bin/mleap-spring-boot
RUN mkdir -p /models
COPY xgboost0124.zip /models
COPY config.json /models
ENV mleap.model.config /models/config.json
RUN chmod +x ./bin/mleap-spring-boot
