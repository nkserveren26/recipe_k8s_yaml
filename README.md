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