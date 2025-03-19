# TP guidé

## Étape 1 : Création d’un Namespace

**Créer un namespace pour isoler votre environnement :**

```shell
kubectl create namespace formation
kubectl get namespaces
```

##  Étape 2 : Déploiement d’un Pod simple (Nginx)

**Créez un fichier pod.yaml :**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mon-pod
  namespace: formation
spec:
  containers:
  - name: web
    image: nginx:alpine
Déploiement :
```

```shell
kubectl create -f pod.yaml
kubectl get pods -n formation
```

## Étape 3 : Création d’un Deployment (Controller)

**Créez un deployment.yaml :**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mon-app
  namespace: formation
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx-container
        image: nginx:alpine
```

**Déploiement :**

```shell
kubectl create -f deployment.yaml
kubectl get deployment -n formation
kubectl get pods -n formation
```

## Étape 3 : Exposition avec un Service

**Créer un fichier service.yaml :**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mon-service
  namespace: formation
spec:
  selector:
    app: web
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

**Déploiement :**

```shell
kubectl create -f service.yaml
kubectl get svc -n formation
```

**Test rapide en local ou via simulateur :**

URL : http://<nodeIP>:30080