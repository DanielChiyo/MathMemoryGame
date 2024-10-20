https://argo-cd.readthedocs.io/en/stable/getting_started/
https://argo-cd.readthedocs.io/en/stable/cli_installation/
https://github.com/badtuxx/DescomplicandoArgoCD/blob/main/pt/src/day-1/README.md#conte%C3%BAdo-do-day-1

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d