# Docker Image for Typecho

基于 [`rehiy/webox:nginx-php8`](https://github.com/rehiy/webox-docker) 构建，支持 x86_64 和 arm64 构架；每周日拉取 [Typecho](https://github.com/typecho/typecho) 主分支代码更新镜像。

## 快速部署

部署完成后，请访问 `http://your-server:8000` 完成数据库设置。

- 如需设置时区可以添加参数 `-e TZ=Asia/Shanghai`
- 系统将自动备份 `config.inc.php` 为 `usr/config.php`，重建时自动恢复

```shell
docker run -d \
  -p 8000:80 -p 8443:443 \
  -v /srv/myblog/usr:/var/www/default/usr \
  rehiy/typecho
```

## K8s 快速部署

将下面的配置导入k8s集群即可完成部署，然后访问 `http://blog.example.com` 完成数据库设置。

- 请注意修改存储路径 `/srv/myblog` 和**博客域名**
- 如果没有配置证书，请删除 `websecure` 和 `tls` 配置
- 如果你没有使用 `traefik.ingress` 请修改为对应的 `Ingress`配置

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: &name myblog
  labels:
    app: *name
spec:
  selector:
    matchLabels:
      app: *name
  template:
    metadata:
      labels:
        app: *name
    spec:
      containers:
        - name: typecho
          image: rehiy/typecho
          ports:
            - containerPort: 80
            - containerPort: 443
          volumeMounts:
            - name: *name
              subPath: usr
              mountPath: /var/www/default/usr
      volumes:
        - name: *name
          hostPath:
            path: /srv/myblog
            type: DirectoryOrCreate
---
kind: Service
apiVersion: v1
metadata:
  name: &name myblog
  labels:
    app: *name
spec:
  selector:
    app: *name
  ports:
    - name: http
      port: 80
      targetPort: 80
    - name: https
      port: 443
      targetPort: 443
---
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: &name myblog
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web,websecure
spec:
  rules:
    - host: blog.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: *name
                port:
                  name: http
  tls:
    - secretName: default
```
