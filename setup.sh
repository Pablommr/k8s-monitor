#!/bin/bash

INSTALL() {
  echo "Creating kubernetes monitoring system"
  echo ""

  #CADVISOR########################################
  echo "Creating namespace"
  kubectl apply -f cadvisor/namespace.yaml
  echo ""

  echo "Creating registry secret"
  kubectl apply -f prometheus/nexus-registry-secret.yaml
  echo ""

  echo "Applying cadvisor system"
  echo "Applying role and policys"
  kubectl apply -f cadvisor/clusterrole.yaml
  kubectl apply -f cadvisor/clusterrolebinding.yaml
  kubectl apply -f cadvisor/podsecuritypolicy.yaml
  kubectl apply -f cadvisor/serviceaccount.yaml
  echo ""

  sleep 5

  echo "Applying cadvisor daemonset"
  kubectl apply -f cadvisor/daemonset.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  #NODE-EXPORTER###################################
  echo "Applying node-exporter system"
  echo "Applying node-exporter daemonset"
  kubectl apply -f node-exporter/ne-daemonset.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  #PROMETHEUS######################################
  echo "Applying prometheus system"
  echo "Applying service"
  kubectl apply -f prometheus/prom-service.yaml
  echo ""

  echo "Applying configmap"
  kubectl apply -f prometheus/prom-config-confmap.yaml
  echo ""

  echo "Creating pvc"
  kubectl apply -f prometheus/prom-pvc.yaml
  echo ""

  echo "Waiting 100 seconds to ensure that pvc was created"
  sleep 100

  echo "Applying prometheus statefulset"
  kubectl apply -f prometheus/prom-statefulset.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  echo "kubernetes monitoring configured"
}

UNINSTALL() {
  echo "Removing kubernetes monitoring system"
  echo ""

  #PROMETHEUS######################################
  echo "Removing prometheus system"
  echo "Deleting prometheus statefulset"
  kubectl delete -f prometheus/prom-statefulset.yaml
  echo ""

  echo "Deleting pvc"
  kubectl delete -f prometheus/prom-pvc.yaml
  echo ""

  echo "Deleting configmap and secret"
  kubectl delete -f prometheus/prom-config-confmap.yaml
  kubectl delete -f prometheus/prom-service.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  #NODE-EXPORTER###################################
  echo "Removing node-exporter system"
  echo "Deleting node-exporter daemonset"
  kubectl delete -f node-exporter/ne-daemonset.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  #CADVISOR########################################
  echo "Removing cadvisor system"
  echo "Deleting cadvisor daemonset"
  kubectl delete -f cadvisor/daemonset.yaml

  echo "Deleting role and policys"
  kubectl delete -f cadvisor/clusterrole.yaml
  kubectl delete -f cadvisor/clusterrolebinding.yaml
  kubectl delete -f cadvisor/podsecuritypolicy.yaml
  kubectl delete -f cadvisor/serviceaccount.yaml
  echo ""

  echo "Deleting registry secret"
  kubectl delete -f prometheus/nexus-registry-secret.yaml
  echo ""

  echo "Deleting namespace"
  kubectl delete -f cadvisor/namespace.yaml
  #################################################

  echo ""
  echo ""
  echo ""

  echo "kubernetes monitoring deleted"
}
#-------------------------------------------------------------

namespace="k8s-monitor"

if kubectl cluster-info; then

  case $1 in
    "install")
      INSTALL
    ;;
    
    "uninstall")
      UNINSTALL
    ;;
    
    *)
      echo "Bad parameter. Choose between install or uninstall"
  esac

else
  echo "Make sure if you're logged in kubernetes cluster"
fi