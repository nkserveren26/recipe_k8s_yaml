## バックエンドアプリの構築メモ
・AWS認証情報を格納するSecretを作成
```bash
kubectl create secret generic aws-credentials \
  --from-literal=AWS_ACCESS_KEY_ID=xxxxxxx \
  --from-literal=AWS_SECRET_ACCESS_KEY=xxxxxx
```

## kubectl のコマンドメモ

### Deployment のデプロイ
```bash
kubectl apply -f backend-deployment.yaml
```

### 指定の Pod のログを表示
```bash
kubectl logs myapp-backend-78f7bd58-nlh22
```

### Deployment 再起動
kubectl rollout restart deployment myapp-backend

### API 実行環境 Pod 起動
```bash
kubectl run test-client --rm -it --image=curlimages/curl -- /bin/sh
```