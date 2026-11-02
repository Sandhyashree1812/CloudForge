# 🔧 Kubernetes Troubleshooting Guide

Common issues and solutions when working with the any Kubernetes project (Specifically added detailed command w.r.t this project).

## 🚨 Common Issues & Solutions

#### Problem: Container Crashes (CrashLoopBackOff)
```bash

# Describe resource
kubectl describe pod <pod-name> -n cloudforge-demo

# Check pod logs
kubectl logs <pod-name> -n cloudforge-demo --previous

# Debug with interactive shell
kubectl exec -it <pod-name> -n cloudforge-demo -- /bin/sh
```

### Networking Issues

#### Problem: Service Not Accessible
```bash
# Verify service endpoints
kubectl get endpoints -n cloudforge-demo

# Test service connectivity
kubectl run debug --image=busybox -it --rm -- nslookup backend.cloudforge-demo

# Check service configuration
kubectl describe service backend -n cloudforge-demo
```

#### Problem: Ingress Not Working
```bash
# Check ingress controller
kubectl get pods -n ingress-nginx

# Verify ingress resource
kubectl describe ingress cloudforge-ingress -n cloudforge-demo

# Check ingress controller logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

### Storage Issues

#### Problem: Persistent Volume Claims Pending
```bash
# Check available storage classes
kubectl get storageclass

# Verify PVC status
kubectl describe pvc mongo-data-mongo-0 -n cloudforge-demo

# Check node storage capacity
kubectl describe nodes
```

### Configuration Issues

#### Problem: ConfigMap/Secret Not Loading
```bash
# Verify ConfigMap exists
kubectl get configmap -n cloudforge-demo

# Check secret data
kubectl get secret db-secret -n cloudforge-demo -o yaml

# Validate environment variables in pod
kubectl exec <pod-name> -n cloudforge-demo -- env | grep MONGODB
```

### Scaling Issues

#### Problem: HPA Not Scaling
```bash
# Check metrics server
kubectl top nodes
kubectl top pods -n cloudforge-demo

# Verify HPA status
kubectl describe hpa backend-hpa -n cloudforge-demo

# Check resource requests/limits
kubectl describe deployment backend -n cloudforge-demo
```

## 🔍 Debugging Commands

### Essential Debugging Toolkit
```bash
# Pod inspection
kubectl get pods -n cloudforge-demo -o wide
kubectl describe pod <pod-name> -n cloudforge-demo
kubectl logs <pod-name> -n cloudforge-demo --follow

# Service debugging
kubectl get svc -n cloudforge-demo
kubectl get endpoints -n cloudforge-demo

# Network debugging
kubectl exec -it <pod-name> -n cloudforge-demo -- nslookup kubernetes.default
kubectl exec -it <pod-name> -n cloudforge-demo -- wget -qO- http://backend:5000/health

# Resource monitoring
kubectl top pods -n cloudforge-demo
kubectl describe node <node-name>

# Event monitoring
kubectl get events -n cloudforge-demo --sort-by='.lastTimestamp'
```

## 🛠 Helm Troubleshooting

### Common Helm Issues
```bash
# Check Helm release status
helm status cloudforge-backend -n cloudforge-demo

# Debug template rendering
helm template cloudforge-backend kubernetes/helm/charts/backend --debug

# Rollback failed deployment
helm rollback cloudforge-backend 1 -n cloudforge-demo

# Check Helm history
helm history cloudforge-backend -n cloudforge-demo
```

## 🔄 ArgoCD Troubleshooting

### ArgoCD Sync Issues
```bash
# Check application status
kubectl get applications -n argocd

# View application details
kubectl describe application cloudforge-umbrella -n argocd

# Force sync
argocd app sync cloudforge-umbrella

# Check ArgoCD server logs
kubectl logs -n argocd deployment/argocd-server
```

## 📊 Performance Troubleshooting

### Resource Monitoring
```bash
# Node resource usage
kubectl top nodes

# Pod resource usage
kubectl top pods -n cloudforge-demo

# Detailed resource metrics
kubectl describe node <node-name> | grep -A 5 "Allocated resources"
```

## 🚨 Emergency Procedures

### Cluster Recovery
```bash
# Check cluster health
kubectl get nodes
kubectl get pods --all-namespaces

# Restart failed deployments
kubectl rollout restart deployment/backend -n cloudforge-demo

# Emergency pod deletion
kubectl delete pod <pod-name> -n cloudforge-demo --force --grace-period=0
```