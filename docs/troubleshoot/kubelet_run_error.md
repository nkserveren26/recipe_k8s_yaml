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
証明書ファイルのバックアップ

```bash
sudo mkdir -p /root/k8s-backup
sudo cp -r /etc/kubernetes /root/k8s-backup/
```