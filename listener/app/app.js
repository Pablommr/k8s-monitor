//Express 
const express = require('express')
const app = express()
//Porta do web server
const port = 3000;
//Arquivos do prometheus com os ips. Cadvisor e Node-exporter
var targets_cadvisor_file = '/etc/prometheus/targets-cadvisor.json'
var targets_nodeexporter_file = '/etc/prometheus/targets-nodeexporter.json'

//File System
var fs = require('fs');

//Cria arquivo targets.json
fs.writeFileSync(targets_cadvisor_file, '[{"labels":{"job":"cadvisor"},"targets":[]}]');
fs.writeFileSync(targets_nodeexporter_file, '[{"labels":{"job":"node-exporter"},"targets":[]}]');


app.post('/cadvisor',(req, res) => {

  //Carrega na variável o arquivo
  const targets_cadvisor = JSON.parse(fs.readFileSync(targets_cadvisor_file))

  //Armazena o ip que foi informado no parâmetro
  var ip = req.query.ip

  //Verifica se o IP foi enviado no parâmetro
  if (typeof ip !== 'undefined' && ip !== null){
    
    //Verifica se o ip já não está no JSON, se não, o adiciona
    var verify = 0
    for (i in targets_cadvisor[0].targets) {
      //Se o ip já estiver na lista. Para execução
      if (targets_cadvisor[0].targets[i] == ip) {
        verify = 1
        break
      }      
    }

    //Se não encontrou o IP na lista, adiciona no último elemento
    if (verify == 0){
      targets_cadvisor[0].targets[targets_cadvisor[0].targets.length] = ip

      fs.writeFileSync(targets_cadvisor_file, JSON.stringify(targets_cadvisor));
    }

    res.status(200).send()
  }
  else {
    res.status(403).send('Não foi informado IP')
  }
})

app.post('/node-exporter',(req, res) => {

  //Carrega na variável o arquivo
  const targets_nodeexporter = JSON.parse(fs.readFileSync(targets_nodeexporter_file))

  //Armazena o ip que foi informado no parâmetro
  var ip = req.query.ip

  //Verifica se o IP foi enviado no parâmetro
  if (typeof ip !== 'undefined' && ip !== null){
    
    //Verifica se o ip já não está no JSON, se não, o adiciona
    var verify = 0
    for (i in targets_nodeexporter[0].targets) {
      //Se o ip já estiver na lista. Para execução
      if (targets_nodeexporter[0].targets[i] == ip) {
        verify = 1
        break
      }      
    }

    //Se não encontrou o IP na lista, adiciona no último elemento
    if (verify == 0){
      targets_nodeexporter[0].targets[targets_nodeexporter[0].targets.length] = ip

      fs.writeFileSync(targets_nodeexporter_file, JSON.stringify(targets_nodeexporter));
    }

    res.status(200).send()
  }
  else {
    res.status(403).send('Não foi informado IP')
  }
})

app.listen(port, () => {
  console.log(`UP: http://localhost:${port}`)
})