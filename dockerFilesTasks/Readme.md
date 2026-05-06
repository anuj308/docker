command used

docker build -t some-image-nginx .

docker run --name some-nginx -p 8080:80 -d some-image-nginx
