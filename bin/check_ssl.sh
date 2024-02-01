#!/bin/bash

#cacert.pem: download this certificate: https://curl.se/ca/cacert.pem
# env to take in:
# LB_IP
# LB_NAME

visual_check (){
	echo "*** MUST: manually verify certification information below. ***"
	echo "quit" | openssl s_client -showcerts -servername server -connect ${LB_IP}:443 > server_cert.pem
	openssl x509 -inform PEM -in server_cert.pem -text -out certdata | egrep "Issuer: |Validity|Not Before: |Not After|Subject:"
	rm certdata
}

POST_test (){
	echo "*** balanceInquiry test below. ***"

	#Temp user on UAT, and before LB_IP is resolved successfully
	#curl --verbose --insecure --user ${POST_USER}:${POST_PASS} -d @req.json -H "Content-Type: application/json" https://${LB_IP}/resourceEndPoint
	
	#on UAT, if LB_IP can be resolved properly
	#on Production. LB_IP must be resolved properly.
	curl --verbose  --cacert cacert.pem --user ${POST_USER}:${POST_PASS} -d @req.json -H "Content-Type: application/json" https://${LB_NAME}/resourceEndPoint

	echo "*** MUST verify above handshake in above logs. ***"
}

POST_USER=a
POST_PASS=b

visual_check
POST_test
