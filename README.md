# Typecho for Docker

## 快速部署

```
docker run -d \
  -p 80:80 -p 443:443 \
  -v ./usr:/var/www/default/usr \
  rehiy/typecho
```
