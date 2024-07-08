resource "kubernetes_manifest" "namespace" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: hello-world
#  sidecars are not required for simple ingress
#  labels:
#    istio-injection: enabled
YAML
  )
}

resource "kubernetes_manifest" "configmap" {
  manifest = yamldecode(<<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: html
  namespace: hello-world
data:
  index.html: hello from ${local.provider}-${local.area}!
YAML
  )
  depends_on = [
    kubernetes_manifest.namespace
  ]
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(<<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: home
  namespace: hello-world
spec:
  selector:
    matchLabels:
      app: home
  replicas: 3
  template:
    metadata:
      labels:
        app: home
    spec:
      volumes:
      - name: html
        configMap:
          name: html
      containers:
      - name: nginx
        image: nginx:1.25.4
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: html
      nodeSelector:
        node.wescaleout.cloud/app: "true"
      tolerations:
      - key: node.wescaleout.cloud/app
        operator: Equal
        value: "true"
        effect: NoSchedule
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
          matchLabels:
            app: home
YAML
  )
  depends_on = [
    kubernetes_manifest.namespace
  ]
}

resource "kubernetes_manifest" "service" {
  manifest = yamldecode(<<YAML
kind: Service
apiVersion: v1
metadata:
  name: home
  namespace: hello-world
spec:
  selector:
    app: home
  ports:
  - name: http
    port: 80
YAML
  )
  depends_on = [
    kubernetes_manifest.namespace
  ]
}
