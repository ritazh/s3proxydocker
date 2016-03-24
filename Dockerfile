FROM java
FROM maven:3

WORKDIR /opt

RUN git clone -b master https://github.com/andrewgaul/s3proxy.git

WORKDIR /opt/s3proxy
RUN mvn package

ADD ./s3proxy.conf /opt/s3proxy/s3proxy.conf

EXPOSE 8080

ENTRYPOINT ./target/s3proxy --properties ./s3proxy.conf

