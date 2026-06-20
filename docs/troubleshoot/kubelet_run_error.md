kubectlコマンドを実行すると以下のエラーが、、
norio@kubenode:~$ kubectl get svc -n argocd
E0612 08:53:31.434733  261378 memcache.go:265] couldn't get current server API group list: Get "https://192.168.3.17:6443/api?timeout=32s": dial tcp 192.168.3.17:6443: connect: connection refused
E0612 08:53:31.435574  261378 memcache.go:265] couldn't get current server API group list: Get "https://192.168.3.17:6443/api?timeout=32s": dial tcp 192.168.3.17:6443: connect: connection refused



kube-apiserver等、Kubernetesのコンポーネントが動いていないか、コンポーネントは動いているが、
何らかの理由でこれらに接続できない可能性


これらのコンポーネントはpodで動いている。
　正確に言うと、Static Pod として kubelet が直接起動している
　API Server を経由せず、kubelet 自身が以下に配置されている、各Kubernetes コンポーネントの manifest を参照し、これらのコンポーネントを Static Pod としてデプロイしている。
　　/etc/kubernetes/manifests

もし、Kubernetes コンポーネントが動いていない場合、
podを動かす役割を果たすkubeletもしくはコンテナランタイムで何か問題が起きている可能性がある。


containerdが動いているか確認
　→起動していることを確認
norio@kubenode:~$ systemctl status containerd
● containerd.service - containerd container runtime
     Loaded: loaded (/lib/systemd/system/containerd.service; enabled; vendor pr>
     Active: active (running) since Wed 2026-06-10 09:01:56 JST; 1 day 23h ago
       Docs: https://containerd.io
   Main PID: 670 (containerd)
      Tasks: 96
     Memory: 92.7M
        CPU: 10min 47.264s
     CGroup: /system.slice/containerd.service
             mq670 /usr/bin/containerd


kubeletが起動しているか確認
　→何らかの理由でエラーが起き、起動のトライを繰り返している模様
norio@kubenode:~$ sudo systemctl status kubelet
[sudo] password for norio:
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor prese>
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             mq10-kubeadm.conf
     Active: activating (auto-restart) (Result: exit-code) since Fri 2026-06-12>
       Docs: https://kubernetes.io/docs/
    Process: 261427 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELE>
   Main PID: 261427 (code=exited, status=1/FAILURE)
        CPU: 53ms




journalctl コマンドで、kubelet関連の journal ログを確認
　kubeletで使用する証明書の有効期限が切れているエラーログが記録されていることを確認
norio@kubenode:~$ sudo journalctl -u kubelet -n 10 --no-pager
 6月 12 08:55:47 kubenode kubelet[261533]: Flag --container-runtime-endpoint has been deprecated, This parameter should be set via the config file specified by the Kubelet's --config flag. See https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/ for more information.
 6月 12 08:55:47 kubenode kubelet[261533]: Flag --pod-infra-container-image has been deprecated, will be removed in a future release. Image garbage collector will get sandbox image information from CRI.
 6月 12 08:55:47 kubenode kubelet[261533]: I0612 08:55:47.616672  261533 server.go:210] "--pod-infra-container-image will not be pruned by the image garbage collector in kubelet and should also be set in the remote runtime"
 6月 12 08:55:47 kubenode kubelet[261533]: I0612 08:55:47.621685  261533 server.go:489] "Kubelet version" kubeletVersion="v1.30.11"
 6月 12 08:55:47 kubenode kubelet[261533]: I0612 08:55:47.621711  261533 server.go:491] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
 6月 12 08:55:47 kubenode kubelet[261533]: I0612 08:55:47.622036  261533 server.go:932] "Client rotation is on, will bootstrap in background"
 6月 12 08:55:47 kubenode kubelet[261533]: E0612 08:55:47.623225  261533 bootstrap.go:266] part of the existing bootstrap client certificate in /etc/kubernetes/kubelet.conf is expired: 2026-04-18 14:08:56 +0000 UTC
 6月 12 08:55:47 kubenode kubelet[261533]: E0612 08:55:47.623270  261533 run.go:74] "command failed" err="failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory"
 6月 12 08:55:47 kubenode systemd[1]: kubelet.service: Main process exited, code=exited, status=1/FAILURE
 6月 12 08


Kubernetes クラスター内部で使用される証明書の有効期限を確認
　以下コマンドでは、以下のファイルを参照するため、root 権限でコマンドを実行する必要がある
　　/etc/kubernetes/admin.conf
　全ての証明書の有効期限が切れていることを確認
　ちなみに証明書は以下に配置されている
　　/etc/kubernetes/pki/
 norio@kubenode:~$ sudo kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[check-expiration] Error reading configuration from the Cluster. Falling back to default configuration

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Apr 18, 2026 14:08 UTC   <invalid>       ca                      no
apiserver                  Apr 18, 2026 14:08 UTC   <invalid>       ca                      no
apiserver-etcd-client      Apr 18, 2026 14:08 UTC   <invalid>       etcd-ca                 no
apiserver-kubelet-client   Apr 18, 2026 14:08 UTC   <invalid>       ca                      no
controller-manager.conf    Apr 18, 2026 14:08 UTC   <invalid>       ca                      no
etcd-healthcheck-client    Apr 18, 2026 14:08 UTC   <invalid>       etcd-ca                 no
etcd-peer                  Apr 18, 2026 14:08 UTC   <invalid>       etcd-ca                 no
etcd-server                Apr 18, 2026 14:08 UTC   <invalid>       etcd-ca                 no
front-proxy-client         Apr 18, 2026 14:08 UTC   <invalid>       front-proxy-ca          no
scheduler.conf             Apr 18, 2026 14:08 UTC   <invalid>       ca                      no
super-admin.conf           Apr 18, 2026 14:08 UTC   <invalid>       ca                      no

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Apr 16, 2035 14:08 UTC   8y              no
etcd-ca                 Apr 16, 2035 14:08 UTC   8y              no
front-proxy-ca          Apr 16, 2035 14:08 UTC   8y              no


以上より、Kubernetes API Server に接続できない原因は、API Server を含む各 Kubernetes コンポーネントの Static Pod が起動していないことが直接原因である。
そして、Static Pod が起動しない原因は、Static Pod をデプロイする役割を果たす kubelet が起動していないことであり、kubeletが起動しない原因は、kubelet が Kubernetes API Server と接続時に使用するクライアント証明書の有効期限が切れているため。


### 証明書の更新
#### 証明書ファイルのバックアップ

バックアップ実施
```bash
sudo mkdir -p /root/k8s-backup
sudo cp -r /etc/kubernetes /root/k8s-backup/
```

ファイルをバックアップできたか確認
```bash
sudo ls /root/k8s-backup/kubernetes
```


#### 証明書の更新
証明書を更新
```bash
sudo kubeadm certs renew all
```


```bash
norio@kubenode:~$ sudo kubeadm certs renew all
[renew] Reading configuration from the cluster...
[renew] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[renew] Error reading configuration from the Cluster. Falling back to default configuration

certificate embedded in the kubeconfig file for the admin to use and for kubeadm itself renewed
certificate for serving the Kubernetes API renewed
certificate the apiserver uses to access etcd renewed
certificate for the API server to connect to kubelet renewed
certificate embedded in the kubeconfig file for the controller manager to use renewed
certificate for liveness probes to healthcheck etcd renewed
certificate for etcd nodes to communicate with each other renewed
certificate for serving etcd renewed
certificate for the front proxy client renewed
certificate embedded in the kubeconfig file for the scheduler manager to use renewed
certificate embedded in the kubeconfig file for the super-admin renewed

Done renewing certificates. You must restart the kube-apiserver, kube-controller-manager, kube-scheduler and etcd, so that they can use the new certificates.
```


更新後、証明書の有効期限を確認
```bash
sudo kubeadm certs check-expiration
```

```bash
norio@kubenode:~$ sudo kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[check-expiration] Error reading configuration from the Cluster. Falling back to default configuration

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Jun 16, 2027 14:05 UTC   364d            ca                      no
apiserver                  Jun 16, 2027 14:05 UTC   364d            ca                      no
apiserver-etcd-client      Jun 16, 2027 14:05 UTC   364d            etcd-ca                 no
apiserver-kubelet-client   Jun 16, 2027 14:05 UTC   364d            ca                      no
controller-manager.conf    Jun 16, 2027 14:05 UTC   364d            ca                      no
etcd-healthcheck-client    Jun 16, 2027 14:05 UTC   364d            etcd-ca                 no
etcd-peer                  Jun 16, 2027 14:05 UTC   364d            etcd-ca                 no
etcd-server                Jun 16, 2027 14:05 UTC   364d            etcd-ca                 no
front-proxy-client         Jun 16, 2027 14:05 UTC   364d            front-proxy-ca          no
scheduler.conf             Jun 16, 2027 14:05 UTC   364d            ca                      no
super-admin.conf           Jun 16, 2027 14:05 UTC   364d            ca                      no

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Apr 16, 2035 14:08 UTC   8y              no
etcd-ca                 Apr 16, 2035 14:08 UTC   8y              no
front-proxy-ca          Apr 16, 2035 14:08 UTC   8y              no
```


#### kubeconfig の更新
証明書更新によって、/etc/kubernetes/admin.conf も更新されるため、kubectl の設定を更新。

```bash
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### kubelet 再起動できるか確認

kubelet 再起動。
```bash
sudo systemctl restart kubelet
```

kubelet の状態確認
```bash
sudo systemctl status kubelet
```

以前起動できず。
```bash
norio@kubenode:~$ sudo systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor prese>
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             mq10-kubeadm.conf
     Active: activating (auto-restart) (Result: exit-code) since Fri 2026-06-19>
       Docs: https://kubernetes.io/docs/
    Process: 980884 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELE>
   Main PID: 980884 (code=exited, status=1/FAILURE)
        CPU: 74ms
```


journalctl コマンドで、kubelet関連の journal ログを確認
　kubeletで使用する証明書の有効期限が切れているエラーログが記録されていることを確認
```bash
norio@kubenode:~$ sudo journalctl -u kubelet -n 10 --no-pager
 6月 19 23:18:59 kubenode kubelet[980793]: Flag --container-runtime-endpoint has been deprecated, This parameter should be set via the config file specified by the Kubelet's --config flag. See https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/ for more information.
 6月 19 23:18:59 kubenode kubelet[980793]: Flag --pod-infra-container-image has been deprecated, will be removed in a future release. Image garbage collector will get sandbox image information from CRI.
 6月 19 23:18:59 kubenode kubelet[980793]: I0619 23:18:59.603978  980793 server.go:210] "--pod-infra-container-image will not be pruned by the image garbage collector in kubelet and should also be set in the remote runtime"
 6月 19 23:18:59 kubenode kubelet[980793]: I0619 23:18:59.607781  980793 server.go:489] "Kubelet version" kubeletVersion="v1.30.11"
 6月 19 23:18:59 kubenode kubelet[980793]: I0619 23:18:59.607804  980793 server.go:491] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
 6月 19 23:18:59 kubenode kubelet[980793]: I0619 23:18:59.608052  980793 server.go:932] "Client rotation is on, will bootstrap in background"
 6月 19 23:18:59 kubenode kubelet[980793]: E0619 23:18:59.609003  980793 bootstrap.go:266] part of the existing bootstrap client certificate in /etc/kubernetes/kubelet.conf is expired: 2026-04-18 14:08:56 +0000 UTC
 6月 19 23:18:59 kubenode kubelet[980793]: E0619 23:18:59.609039  980793 run.go:74] "command failed" err="failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory"
 6月 19 23:18:59 kubenode systemd[1]: kubelet.service: Main process exited, code=exited, status=1/FAILURE
 6月 19 23:18:59 kubenode systemd[1]: kubelet.service: Failed with result 'exit-code'.
```

kubelet が使用する証明書を確認
　/var/lib/kubelet/pki/kubelet-client-current.pem を使っていることが分かる。
```bash
norio@kubenode:~$ sudo grep client-certificate /etc/kubernetes/kubelet.conf
    client-certificate: /var/lib/kubelet/pki/kubelet-client-current.pem
```

上記コマンドで確認した証明書を ls コマンドで確認
kubelet-client-current.pem のシンボリックリンクが kubelet-client-2025-04-18-23-08-57.pem となっており、この証明書を使用していることが分かる。
```bash
norio@kubenode:~$ sudo ls -l /var/lib/kubelet/pki/
total 12
-rw------- 1 root root 2822  4月 18  2025 kubelet-client-2025-04-18-23-08-57.pem
lrwxrwxrwx 1 root root   59  4月 18  2025 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2025-04-18-23-08-57.pem
-rw-r--r-- 1 root root 2270  4月 18  2025 kubelet.crt
-rw------- 1 root root 1675  4月 18  2025 kubelet.key
```

上記証明書の有効期限を確認
　notAfter が「Apr 18 14:08:56 2026 GMT」となっており、期限が切れていることを確認
　journalログに記録されていた「2026-04-18 14:08:56 +0000 UTC」と一致
```bash
norio@kubenode:~$ sudo openssl x509 \
  -in /var/lib/kubelet/pki/kubelet-client-2025-04-18-23-08-57.pem \
  -noout -dates
notBefore=Apr 18 14:03:54 2025 GMT
notAfter=Apr 18 14:08:56 2026 GMT
```


### kubelet.conf 再作成
kubelet が使用するクライアント証明書を退避
```bash
sudo mv /var/lib/kubelet/pki/kubelet-client-current.pem /var/lib/kubelet/pki/kubelet-client-current.pem.bak
```

kubelet.conf ファイルを退避
　kubelet.conf ファイルを別のファイル名に変更して退避しないと、後述の kubelet.conf の再作成ができない
　（すでに kubelet.conf というファイルが存在していると kubelet.conf ファイルの再作成ができない）
```bash
sudo mv /etc/kubernetes/kubelet.conf /etc/kubernetes/kubelet.conf.bak
```

kubelet.conf 再作成
```bash
norio@kubenode:~$ sudo kubeadm init phase kubeconfig kubelet
I0620 21:08:16.474874 1066291 version.go:256] remote version is much newer: v1.36.2; falling back to: stable-1.30
[kubeconfig] Writing "kubelet.conf" kubeconfig file
```

kubelet.conf が更新されたか確認
```bash
norio@kubenode:~$ ls -l /etc/kubernetes/
total 52
-rw------- 1 root root 5656  6月 16 23:05 admin.conf
-rw------- 1 root root 5680  6月 16 23:05 controller-manager.conf
-rw------- 1 root root 5660  6月 20 21:08 kubelet.conf
-rw------- 1 root root 1976  4月 18  2025 kubelet.conf.bak
drwxrwxr-x 2 root root 4096 11月  2  2025 manifests
drwxr-xr-x 3 root root 4096  4月 18  2025 pki
-rw------- 1 root root 5628  6月 16 23:05 scheduler.conf
-rw------- 1 root root 5680  6月 16 23:05 super-admin.conf
```



kubelet.conf のクライアント証明書情報を確認
```bash
norio@kubenode:~$ sudo grep client-certificate /etc/kubernetes/kubelet.conf
    client-certificate-data: '<証明書データの Base64 文字列>'
```


上記コマンドで得た証明書データの Base64 エンコード文字列を使って、クライアント証明書の有効期限を確認
　notAfter の期限を確認し、証明書の有効期限が更新されていることを確認
```bash
norio@kubenode:~$ echo '<証明書データの Base64 文字列>' | base64 -d | openssl x509 -noout -dates
notBefore=Apr 18 14:03:54 2025 GMT
notAfter=Jun 20 12:08:16 2027 GMT
```

kubelet が内部で使用する証明書が配置されているディレクトリを確認
　kubelet-client-current.pem が再作成され、シンボリックリンク先が「/var/lib/kubelet/pki/kubelet-client-2026-06-20-21-08-50.pem」になっている
　/var/lib/kubelet/pki/kubelet-client-2026-06-20-21-08-50.pem も kubelet.conf 再作成時に一緒に作られたもの
```bash
norio@kubenode:~$ ls -l /var/lib/kubelet/pki/
total 20
-rw------- 1 root root 2822  4月 18  2025 kubelet-client-2025-04-18-23-08-57.pem
-rw------- 1 root root 2822  6月 20 21:08 kubelet-client-2026-06-20-21-08-24.pem
-rw------- 1 root root 1110  6月 20 21:08 kubelet-client-2026-06-20-21-08-50.pem
lrwxrwxrwx 1 root root   59  6月 20 21:08 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2026-06-20-21-08-50.pem
lrwxrwxrwx 1 root root   59  4月 18  2025 kubelet-client-current.pem.bak -> /var/lib/kubelet/pki/kubelet-client-2025-04-18-23-08-57.pem
-rw-r--r-- 1 root root 2270  4月 18  2025 kubelet.crt
-rw------- 1 root root 1675  4月 18  2025 kubelet.key
```


### kubelet 再起動できるか確認
kubelet 再起動
```bash
sudo systemctl restart kubelet
```


kubelet を起動できたか確認
```bash
sudo systemctl status kubele
```

Active になっていることを確認
```bash
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             mq10-kubeadm.conf
     Active: active (running) since Sat 2026-06-20 21:25:32 JST; 10s ago
       Docs: https://kubernetes.io/docs/
   Main PID: 1083009 (kubelet)
      Tasks: 12 (limit: 18828)
     Memory: 35.5M
        CPU: 1.159s
     CGroup: /system.slice/kubelet.service
             mq1083009 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/e>
```


Kubernetes クラスターの Control Plane の各コンポーネントの Pod が起動しているか確認
　STATUS が Running になっていれば OK
```bash
norio@kubenode:~$ kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS       AGE
calico-kube-controllers-6df7596dbd-t6qrn   1/1     Running   30 (10d ago)   427d
calico-node-slsxh                          1/1     Running   27 (10d ago)   427d
coredns-55cb58b774-d4nmt                   1/1     Running   27 (10d ago)   427d
coredns-55cb58b774-rnqvp                   1/1     Running   27 (10d ago)   427d
etcd-kubenode                              1/1     Running   27 (10d ago)   427d
kube-apiserver-kubenode                    1/1     Running   28 (10d ago)   427d
kube-controller-manager-kubenode           1/1     Running   28 (10d ago)   427d
kube-proxy-952lc                           1/1     Running   27 (10d ago)   427d
kube-scheduler-kubenode                    1/1     Running   28 (10d ago)   427d
```