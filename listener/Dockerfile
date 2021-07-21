FROM node:15.10.0-alpine3.10

WORKDIR /app

COPY app/ /app
COPY app/targets-cadvisor.json /etc/prometheus/targets-cadvisor.json
COPY app/targets-nodeexporter.json /etc/prometheus/targets-nodeexporter.json

RUN npm install

EXPOSE 3000

ENTRYPOINT npm start