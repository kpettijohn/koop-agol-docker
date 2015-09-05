FROM node:0.10-slim

ENV APP_DIR /usr/src/koop/
ENV KOOP_DATA_DIR /var/lib/koop

RUN apt-get update \
  && apt-get install -y gdal-bin postgresql-client-9.4 git ca-certificates \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p $APP_DIR \
  && mkdir -p $KOOP_DATA_DIR

WORKDIR $APP_DIR

COPY package.json $APP_DIR

RUN npm install

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY . $APP_DIR

#RUN ln -sf /dev/stdout /tmp/koop.log

EXPOSE 8000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["koop"]
