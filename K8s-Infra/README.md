## Create namespace
kubectl apply -f k8s-namespace.yaml

## Create ingress for frontend
kubectl apply -f ingress-frontend.yaml -n <<namespace>>

## Create ingress for backend
kubectl apply -f ingress-backend.yaml -n <<namespace>>

## store for Kubernetes Architecture

[azure-docs](https://github.com/MicrosoftDocs/azure-docs/tree/master/articles/aks)
