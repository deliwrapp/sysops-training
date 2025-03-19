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
