#!/bin/bash
export KUBECONFIG=/home/vagrant/.kube/config
/usr/bin/kubectl create deployment --image=nginx nginx
/usr/bin/kubectl expose deployment nginx --port=80 --target-port=80

cat <<EOF | /usr/bin/kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginx
  annotations:
    # use the shared ingress-nginx
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: nginx.172.25.10.50.nip.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
EOF

for i in $(/usr/bin/kubectl -n metallb-system get pods | grep -v NAME | awk {'print $1'}); do /usr/bin/kubectl -n metallb-system delete pod $i; done
