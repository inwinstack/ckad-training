kubectl apply -f exercise-01-namespace.yaml
kubectl apply -f .
kubectl config set-context $(k config current-context) --namespace=exercise-01
watch  'kubectl get pod -l app=wordpress -o name | while read pod; do echo; echo --- $pod; echo; kubectl logs $pod|tail -15; done'
