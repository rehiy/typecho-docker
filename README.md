# Docker Image for Typecho

基于 [`rehiy/webox:nginx-php8`](https://github.com/rehiy/webox-docker) 构建， 支持 x86_64 和 arm64 构架。

## 快速部署

```
docker run -d \
  -p 8000:80 -p 8443:443 \
  -v ./usr:/var/www/default/usr \
  rehiy/typecho
```
