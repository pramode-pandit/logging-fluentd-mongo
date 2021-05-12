
mkdir -p certs

openssl req -x509 -newkey rsa:4096	-sha256 -nodes -keyout certs/tls.key -out certs/tls.crt -days 365 \
-subj "/C=US/ST=CA/O=Example Org/CN=mongo-client.app.openkube.io"

kubectl create secret tls tls-mongo-client --cert=certs/tls.crt --key=certs/tls.key --namespace mongo

