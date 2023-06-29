#!/bin/sh 
# cleanup a 


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm repo add eks https://aws.github.io/eks-charts

# install nginx 
helm install nginx ingress-nginx/ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.ingressClassResource.default=true \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb"