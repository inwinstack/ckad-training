kubectl apply -f exercise-02-namespace.yaml
kubectl apply -f .
kubectl config set-context $(k config current-context) --namespace=exercise-02
watch  'kubectl get pod -l app=wordpress -o name | while read pod; do echo; echo --- $pod; echo; kubectl logs $pod|tail -15; done'
