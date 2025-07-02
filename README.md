## バックエンドアプリの構築メモ
・AWS認証情報を格納するSecretを作成
```bash
kubectl create secret generic aws-credentials \
  --from-literal=AWS_ACCESS_KEY_ID=xxxxxxx \
  --from-literal=AWS_SECRET_ACCESS_KEY=xxxxxx
```

## kubectl のコマンドメモ
