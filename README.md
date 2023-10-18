# Docker Image for Typecho

基于 [`rehiy/webox:nginx-php7`](https://github.com/rehiy/webox-docker) 构建， 支持 x86_64 和 arm 构架。

## 快速部署

```
docker run -d \
  -p 8000:80 -p 0443:443 \
  -v ./usr:/var/www/default/usr \
  rehiy/typecho
```
