#!/bin/sh

cnf_dir='/mnt/openssl/'
certs_dir='/etc/ssl/certs/'
openssl req -config ${cnf_dir}clipCA.cnf -new -x509 -days 1 -keyout ${certs_dir}clipCA.key -out ${certs_dir}clipCA.crt
openssl req -config ${cnf_dir}clipCert.cnf -new -out /tmp/clip-dev.csr -keyout ${certs_dir}clip-dev.key
openssl x509 -req -in /tmp/clip-dev.csr -CA ${certs_dir}clipCA.crt -CAkey ${certs_dir}clipCA.key -CAcreateserial -extensions req_ext -extfile ${cnf_dir}clipCert.cnf -sha512 -days 1 -out ${certs_dir}clip-dev.crt

exec "$@"
