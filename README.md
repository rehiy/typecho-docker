# Docker Image for Typecho

基于 [`rehiy/webox:nginx-php8`](https://github.com/rehiy/webox-docker/tree/master/nginx-php8.3) 构建，支持 x86_64 和 arm64 构架；每周日拉取 [Typecho](https://github.com/typecho/typecho) 主分支代码更新镜像。

- 为方便持久化，已修改配置文件 `config.inc.php` 为 `usr/misc/config.php`
- 时区默认使用**UTC**，如需更改时区，可在容器配置中添加环境变量 `TZ=Asia/Shanghai`
- 其他配置可参考 [rehiy/nginx-php8](https://github.com/rehiy/webox-docker/tree/master/nginx-php8.3) 文档，可实现自定义SSL配置、执行自定义脚本等个性化能力

## Docker 快速部署

执行下面的脚本完成部署，然后访问 `http://your-server:8000` 设置数据库和管理员账号。

- 请注意修改存储路径 `/srv/myblog` 和**端口号**

```shell
docker run -d \
  -p 8000:80 -p 8443:443 \
  -v /srv/myblog/backups:/var/www/default/usr/backups \
  -v /srv/myblog/uploads:/var/www/default/usr/uploads \
  -v /srv/myblog/misc:/var/www/default/usr/misc \
  rehiy/typecho
```

## K8s 快速部署

将下面的配置导入k8s集群即可完成部署，然后访问 `http://blog.example.com` 设置数据库和管理员账号。

- 请注意修改存储路径 `/srv/myblog` 和**博客域名**
- 如果没有配置证书，请删除 `websecure` 和 `tls` 配置
- 如果没有使用 `traefik.ingress` 请修改为对应的 `Ingress`配置

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
              subPath: backups
              mountPath: /var/www/default/usr/backups
            - name: *name
              subPath: uploads
              mountPath: /var/www/default/usr/uploads
            - name: *name
              subPath: misc
              mountPath: /var/www/default/usr/misc
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
