#!/bin/bash

#IP do cadvisor/node-exporter que é obtido pelo downward api
IP="$IP"
#Porta que o Cadvisor/node-exporter escuta
PORT="$PORT"
#URL do Prometheus
SERVICEPROM="$SERVICEPROM"
#Parametro da URL. Deve ser cadvisor ou node-exporter
URLPARAM="$URLPARAM"

curl -s --connect-timeout 5 -X POST http://$SERVICEPROM/$URLPARAM?ip=$IP:$PORT