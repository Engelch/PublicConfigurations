FROM nginx
RUN mkdir -p /opt/html
copy index.html /opt/html/index.html
RUN mkdir -p /etc/nginx/certs
copy certificate.crt /etc/nginx/certs/certificate.crt
copy privateKey.key /etc/nginx/certs/privateKey.key
COPY nginxP443.conf /etc/nginx/conf.d/p443.conf
