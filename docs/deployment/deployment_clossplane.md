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

