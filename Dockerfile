FROM eclipse-temurin:25-jre

ENV MEMORY=1024M \
    EULA=true \
    SERVER_PORT=8888

WORKDIR /opt/minecraft

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -o server.jar https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar

RUN echo '#!/bin/sh\n\
cd /data\n\
echo "eula=${EULA}" > eula.txt\n\
exec java -Xms${MEMORY} -Xmx${MEMORY} -jar /opt/minecraft/server.jar nogui --port ${SERVER_PORT}' \
> /start.sh && chmod +x /start.sh

VOLUME ["/data"]

EXPOSE 8888

CMD ["/start.sh"]