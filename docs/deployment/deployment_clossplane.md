# Crossplane 構築メモ

## Helm  インストール

```bash
$ curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

Helm がインストールされたか確認。
```bash
$ helm version
version.BuildInfo{Version:"v3.22.1", GitCommit:"d6c1a0e4027caa6abc7892e7ea9f0cda7447baa3", GitTreeState:"clean", GoVersion:"go1.26.9"}
```


Enable the Crossplane Helm Chart repository
```bash
$ helm repo add \
crossplane-stable https://charts.crossplane.io/stable
```

Install the Crossplane components
```bash
$ helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system
```


Verify Crossplane installed with kubectl get pods.
```bash
$ kubectl get pods -n crossplane-system
NAME                                       READY   STATUS    RESTARTS   AGE
crossplane-795794dd85-hnk62                1/1     Running   0          5m26s
crossplane-rbac-manager-8694755987-jr9ln   1/1     Running   0          5m26s
```

Crossplaneのバージョン確認。
```bash
helm list -n crossplane-system
NAME      	NAMESPACE        	REVISION	UPDATED                                	STATUS  	CHART           	APP VERSION
crossplane	crossplane-system	1       	2026-11-13 07:20:51.870899356 +0900 JST	deployed	crossplane-2.4.3	2.4.3
```