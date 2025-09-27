## バックエンドアプリの構築メモ
・AWS認証情報を格納するSecretを作成
```bash
kubectl create secret generic aws-credentials \
  --from-literal=AWS_ACCESS_KEY_ID=xxxxxxx \
  --from-literal=AWS_SECRET_ACCESS_KEY=xxxxxx
```

・DBユーザーのパスワードを格納するSecretを作成
```bash
kubectl create secret generic db-secret \
  --from-literal=DB_PASSWORD=xxxxxx
```

・DB 接続情報を格納する ConfigMap を作成
```bash
kubectl apply -f db-configmap.yaml
```

・Deployment 作成
```bash
kubectl apply -f backend-deployment.yaml
```

・Service 作成
```bash
kubectl apply -f backend-service.yaml
```

## フロントエンドアプリの構築メモ

・Deployment 作成
```bash
kubectl apply -f frontend-deployment.yaml
```

・Service 作成
```bash
kubectl apply -f fronend-service.yaml
```

## Ingress 構築

### Nginx Ingress Controller の構築

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

```

## デプロイパイプライン構築

### Argo CD インストール

・Argo CD 専用の namespace 作成
```bash
kubectl create namespace argocd
```

・argocd namespace に、Argo CD のリソースを作成
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

・Argo CD CLI インストール
```bash
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

・argocd-server service のタイプを「NodePort」に変更
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'
```

・Argo CD の admin ユーザーのパスワード確認
```bash
argocd admin initial-password -n argocd
```

### Argo CD でのデプロイ設定時のメモ

・監視対象のリポジトリ内ディレクトリの中のファイル群を読み込む設定で、再帰的に読み込むようにする
recursive にチェックを入れる。

## Cloudflare の設定メモ

### Cloudflare のアカウント登録

### Cloudflare にドメインを登録

### Cloudflare の Zero-Trust 設定

### Kubernetes クラスターにトークン用Secret作成

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-tunnel-secret
type: Opaque
stringData:
  TUNNEL_TOKEN: YOUR-TUNNEL-TOKEN-HERE
```

### cloudflared が動く pod を Deplyment で作成

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloudflared-deployment
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      pod: cloudflared
  template:
    metadata:
      labels:
        pod: cloudflared
    spec:
      securityContext:
        sysctls:
        # Allows ICMP traffic (ping, traceroute) to resources behind cloudflared.
          - name: net.ipv4.ping_group_range
            value: "65532 65532"
      containers:
        - image: cloudflare/cloudflared:latest
          name: cloudflared
          env:
            # Defines an environment variable for the tunnel token.
            - name: TUNNEL_TOKEN
              valueFrom:
                secretKeyRef:
                  name: cloudflare-tunnel-secret
                  key: TUNNEL_TOKEN
          command:
            # Configures tunnel run parameters
            - cloudflared
            - tunnel
            - --no-autoupdate
            - --loglevel
            - debug
            - --metrics
            - 0.0.0.0:2000
            - run
          livenessProbe:
            httpGet:
              # Cloudflared has a /ready endpoint which returns 200 if and only if
              # it has an active connection to Cloudflare's network.
              path: /ready
              port: 2000
            failureThreshold: 1
            initialDelaySeconds: 10
            periodSeconds: 10
          resources:
            requests:
              cpu: "250m"
              memory: "512Mi"
            limits:
              cpu: "500m"
              memory: "1Gi"
```

### Pod のログを確認
```bash
kubectl logs pod/cloudflared-deployment-6d5f9f9666-85l5w
```

以下のようなログが出ていればOK
```bash
2025-06-11T22:00:47Z INF Starting tunnel tunnelID=64c359b6-e111-40ec-a3a9-199c2a656613
2025-06-11T22:00:47Z INF Version 2025.6.0 (Checksum 72f233bb55199093961bf099ad62d491db58819df34b071ab231f622deff33ce)
2025-06-11T22:00:47Z INF GOOS: linux, GOVersion: go1.24.2, GoArch: amd64
2025-06-11T22:00:47Z INF Settings: map[loglevel:debug metrics:0.0.0.0:2000 no-autoupdate:true token:*****]
2025-06-11T22:00:47Z INF Generated Connector ID: aff7c4a0-85a3-4ac9-8475-1e0aa1af8d94
2025-06-11T22:00:47Z DBG Fetched protocol: quic
2025-06-11T22:00:47Z INF Initial protocol quic
...
```


## kubectl のコマンドメモ

### Deployment のデプロイ
```bash
kubectl apply -f backend-deployment.yaml
```

### Pod に登録されている特定の環境変数を表示
```bash
kubectl exec -it <pod-name> -- printenv | grep AWS
```

### 指定の Pod のログを表示
```bash
kubectl logs ＜Pod名＞
```

### Deployment 再起動
```bash
kubectl rollout restart deployment ＜Deployment名＞
```

### API 実行環境 Pod 起動
```bash
kubectl run test-client --rm -it --image=curlimages/curl -- /bin/sh
```

### Pod の IP を表示
```bash
kubectl get pod -o wide
```

### Deployment を削除
```bash
kubectl delete deployment ＜Deployment名＞
```

### Secret の一覧を表示
```bash
kubectl get secret
```

### ConfigMap の一覧を表示
```bash
kubectl get configmap
```