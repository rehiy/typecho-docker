# Typecho for Docker

## 快速部署

```
touch config.php
docker run -d \
  -p 80:80 -p 443:443 \
  -v ./usr:/var/www/default/usr \
  rehiy/typecho
```
