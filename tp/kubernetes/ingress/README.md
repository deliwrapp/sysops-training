# TP guidé : création Ingress & Persistance

## Étape 1 – Préparation environnement

**Lancement Minikube avec ingress activé :**

```shell
minikube start
minikube addons enable ingress
```

## Étape 2 – Déploiement d’une application simple avec Ingress

**Service web exposé via ingress (exemple précédent utilisé).**

```shell
kubectl apply -f ingress.yaml
kubectl get ingress
```

## Étape 3 – Mise en place stockage persistant

**Création PersistentVolumeClaim :**

```shell
kubectl apply -f pvc.yaml
kubectl get pvc
```

**Créer Pod utilisant le PVC :**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-persistent
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: "/usr/share/nginx/html"
      name: html-volume
  volumes:
  - name: html-storage
    persistentVolumeClaim:
      claimName: mon-pvc
```

**Lancer :**

```shell
kubectl apply -f pod-persistent.yaml
```


## Gestion de l’exposition réseau avec Ingress

**🔹 Pourquoi un Ingress ?**

- Simplifie l’exposition externe des applications Kubernetes.
- Permet une gestion avancée du trafic (routing, SSL/TLS, domaines multiples).

**🔹 Architecture Ingress simplifiée :**

```java
Utilisateur externe
      │
      │
    Ingress
      │
      ├── service web (Pod Web)
      ├── service api (Pod API)
      └── autres services internes
```

- L’Ingress redirige le trafic HTTP/HTTPS vers les services appropriés selon les règles définies.

**🔹 Exemple YAML d’un Ingress basique :**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-demo
spec:
  rules:
  - host: "web.exemple.com"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mon-service-web
            port:
              number: 80
```

**Commande pour créer un Ingress :**

```shell
kubectl apply -f ingress.yaml
```

## Persistance des données dans Kubernetes

**📌 Pourquoi persister des données ?**

- Par défaut, les Pods sont éphémères, les données disparaissent à leur destruction.
- Nécessité de stocker durablement les données critiques (BDD, stockage fichiers).

**Volumes Kubernetes**

- Stockage associé directement à un Pod (éphémère ou persistant).

**PersistentVolumes (PV) et PersistentVolumeClaims (PVC)**

- PersistentVolume (PV) : ressource de stockage durable provisionnée dans le cluster.
- PersistentVolumeClaim (PVC) : demande de stockage persistante effectuée par un Pod.

**Exemple YAML (PVC simple) :**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mon-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

**Attacher un PVC à un Pod :**

```yaml
spec:
  containers:
  - name: web-container
    image: nginx
    volumeMounts:
    - mountPath: "/usr/share/nginx/html"
      name: webdata
  volumes:
  - name: webdata
    persistentVolumeClaim:
      claimName: pvc-mon-web
```

## TP guidé : création Ingress & Persistance

### Étape 1 – Préparation environnement

**Lancement Minikube avec ingress activé :**

```shell
minikube start
minikube addons enable ingress
```

### Étape 2 – Déploiement d’une application simple avec Ingress

**Service web exposé via ingress (exemple précédent utilisé).**

```shell
kubectl apply -f ingress.yaml
kubectl get ingress
```

### Étape 3 – Mise en place stockage persistant

**Création PersistentVolumeClaim :**

```shell
kubectl apply -f pvc.yaml
kubectl get pvc
```

**Créer Pod utilisant le PVC :**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-persistent
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: "/usr/share/nginx/html"
      name: html-volume
  volumes:
  - name: html-storage
    persistentVolumeClaim:
      claimName: mon-pvc
```

**Lancer :**

```shell
kubectl apply -f pod-persistent.yaml
```
