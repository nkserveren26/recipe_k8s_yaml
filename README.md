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