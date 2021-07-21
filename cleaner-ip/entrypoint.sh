#!/bin/bash

DIR_TARGET_CADVISOR="/etc/prometheus/targets-cadvisor.json"
DIR_TARGET_NODEEXPORTER="/etc/prometheus/targets-nodeexporter.json"

if [ -z "$DIR_TARGET_CADVISOR" ] || [ -z "$DIR_TARGET_NODEEXPORTER" ]; then

  echo "{\"msg\":\"Error: Informar variáveis DIR_TARGET_CADVISOR e DIR_TARGET_NODEEXPORTER\"}"
  exit 1

else

  #armazena nas variaves os targets-json
  targets_cadvisor="$(cat $DIR_TARGET_CADVISOR)"
  targets_nodeexporter="$(cat $DIR_TARGET_NODEEXPORTER)"

fi

#Timeout do telnet
TIMEOUT=3

#===================================================================
#Lista e deleta ip que nao conseguiram realizar telnets
VERIFY_IPS() {

  if [ "$1" == "cadvisor" ]; then
    targets="$targets_cadvisor"
  elif [ "$1" == "nodeexporter" ]; then
    targets="$targets_nodeexporter"
  else
    echo "{\"msg\":\"Parâmetro inexistente. Opções válidas: cadvisor ou nodeexporter\"}"
    exit 1
  fi

  #Variavel usada para verificar se existem ips a serem alterados
  VERIFY=false
  
  #Passa por todos os elementos do target
  i=0
  qtd_ip=$(echo -n $targets |jq '.[0].targets[]' |wc -l)
  while [ $i -lt $qtd_ip ]
  do
  
    #Separa URL e porta nas variaveis
    REMOTEHOST=$(echo -n $targets |jq ".[0].targets[$i]" |tr -d '"' |cut -f 1 -d ":")
    REMOTEPORT=$(echo -n $targets |jq ".[0].targets[$i]" |tr -d '"' |cut -f 2 -d ":")
    
    if nc -w $TIMEOUT -z $REMOTEHOST $REMOTEPORT; then
        echo "{\"msg\":\"I was able to connect to ${REMOTEHOST}:${REMOTEPORT}. Nothing to do \"}"
    else
        echo ""{\"msg\":\"Connection to ${REMOTEHOST}:${REMOTEPORT} failed."\"}"
        #Verifica se existe valor em J
        if [ -z $j ]; then
          j="$i"
        else
          j="$j,$i"
        fi
        #Seta a variavel para ture, informando que existem valores a serem tirados do array
        VERIFY=true
    fi
  
    true $(( i++ ))
  done
  
  #Verifica se tem IPs a serem alterados
  if $VERIFY; then
      if [ "$1" == "cadvisor" ]; then
        echo -n "$targets" |jq -c "del(.[0].targets[$j])" |tr -d "\n" > $DIR_TARGET_CADVISOR
      elif [ "$1" == "nodeexporter" ]; then
        echo -n "$targets" |jq -c "del(.[0].targets[$j])" |tr -d "\n" > $DIR_TARGET_NODEEXPORTER
      else
        echo "{\"msg\":\"Parâmetro inexistente. Opções válidas: cadvisor ou nodeexporter\"}"
        exit 1
      fi
  fi

  #Zera a variavel j
  unset j
}

#Cadvisor
VERIFY_IPS cadvisor

#Node exporter
VERIFY_IPS nodeexporter