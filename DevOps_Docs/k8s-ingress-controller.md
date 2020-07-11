# Create an HTTPS ingress controller on Azure Kubernetes Service (AKS)

## Create an ingress controller
```
Create a namespace for your ingress resources
kubectl create namespace ingress-basic

Add the official stable repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

Use Helm to deploy an NGINX ingress controller
helm install nginx stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

## Get the LoadBalancer IP to access Ingress controller
```
kubectl get service -l app=nginx-ingress --namespace ingress-basic
```

## Add an A record to your DNS zone
```
Point domain name to the LoadBalancer IP 
``` 

## Install cert-manager
```
Install the CustomResourceDefinition resources separately
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml --namespace ingress-basic

Label the ingress-basic namespace to disable resource validation
kubectl label namespace ingress-basic certmanager.k8s.io/disable-validation=true

Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

Update your local Helm chart repository cache
helm repo update

Install the cert-manager Helm chart
helm install cert-manager --namespace ingress-basic --version v0.12.0 jetstack/cert-manager --set ingressShim.defaultIssuerName=letsencrypt --set ingressShim.defaultIssuerKind=ClusterIssuer
```

## Create a CA cluster issuer
```
cat <<EOF | kubectl apply -n ingress-basic -f -
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: MY_EMAIL_ADDRESS
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```


## Create an ingress route
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: bis-backend-app-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt
spec:
  tls:
  - hosts:
    - <<Replace with bis-backend-app url>>
    secretName: tls-secret
  rules:
  - host: <<Replace with bis-backend-app url>>
    http:
      paths:
      - backend:
          serviceName: bis-backend-app-develop
          servicePort: 80
```

## Verify a certificate object has been created
```
kubectl get certificate --namespace ingress-basic
```

## Clean up resources
```
Delete the sample namespace and all resources

kubectl delete ClusterIssuer letsencrypt
helm list --namespace ingress-basic

helm delete cert-manager nginx --namespace ingress-basic

kubectl delete ingress bis-backend-app-ingress -n bis-develop
kubectl delete namespace ingress-basic
```