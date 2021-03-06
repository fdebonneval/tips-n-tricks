#!/bin/bash

apt-get update
apt-get install -y nginx openssl php5-fpm

mkdir /etc/nginx/ssl

cat > /etc/nginx/ssl/server.key <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMLgOO3nVciTMB
//53TONoheAaRIQ70NmbHrwzdycf/yTLv2D5nrYHP40HPJz1deR8tkTMX0omjVkT
SZFk1I/fAraz3XwtAGGsSUfZknL9xjtCBLMbqd721e9o8DGhVy+J1K+EtoFNcHih
1CaJbhg3yjHHQo+YEz2cD9MsEqIudPnd2l8E4upsYQ7i39bYAUtbXwK01xz3OVdO
xcUaMgVcsnbMJbij6qxFp8JlwxolpoOCpraa2U8UzoSWUdUOWD/8WDrO09Rat4kB
M+AKtil17iRJg9+Jnn8V1o0OOCaJpA998aFnuPR/E85pi42S2dgzrsarelQ0giYX
Okr9RRphAgMBAAECggEAeXBIt3nCbeZAS0k5zTUS8IDnmFf2GimOs38lSqrsv1Ae
T3ylLfJiq471zz8Sz79txWsXIkLutF1PhHQ2ILV4WJihl/r8tztJ3JG9RT+gWyXC
6vImoSZ4sXDuswhhTGexo5W3SwTNhQSHCyFGRmkPyGbfEneZNkcDVsXmwIjYoy3p
Fb9iyqXC3Lpso1XobeCN0K+nfUPf1Kb6eIdamdAbCiEkndZ/7MVQdCu/C+QnJ0aF
+/N1FSAMfYhdikKFp02h3d9qUk03/HFMJzXDOensD1hk6un0hpDumK6DamuyfCpY
lnfYXW0HW773U9t+1L1KqlRwoaxg7lzPbPA31hBETQKBgQD2N9QrhHCDerkIaYY0
8gpnTf86+pbO7bREUGuIu31Ls98UVeKkmW+5xEfckKp1zaqHXCmVB5512EID+5mC
saYWLvd25gxmEvfDt74BbcG2p+EONZQdDGVksTdB6Yy0Cw9cv5jKrxO5ut6NLHcS
mYsWLbPe1ngvlD6SyQ9rJugRzwKBgQDUSqHnOZdwtPMkvu/vM2j+EKlUfFec3Xch
Wol52ubleisDAF9EpXEvsWBMBvnmB8hNcQP1Pw00vVdX6eszqNbbBtRwmBXhHHCy
7VSEKL1R4tkMko4Of+ShCewkDZcdTMk/XU6sU0wv2j2F5CsgrIE/TAej98ixJHIq
6hQ5W+cMzwKBgQCGR8Bg02QBcMbE/bgB3Bcsa+9MnSnuRNlRgIKFGaulw71f+88V
cdDrAU8nzYYJpVbhZ7QN4Q/cuUqXnXoFOxmXc5nmsGQGr0WM6gKoCNHi6f/lnfbf
OMl7duLqAZOJBZclQCD2OTGK041YdO2jqTWfrOEyIMl/OVw+9YSBLcDXJQKBgCHD
SOKUZ0B2luD2OQSrAXy+u5+DMw/wrPyyAIFPzj8a4fJVQdGSGmFCbZVJ2r656CJg
4gdEIt6LanPB8TVDGgC1ol3R4lDuDAJ4+mMWc52tXWXBfTRTJNJz2ImXW7w+NReN
yHBhwxEtPXGo6y8EIH4nomNyigmaSUoH9nV051dDAoGAaQXZ73ZAlcDmaIz4BngW
Rr8HwBEcthSl2KGutXpu+M9FsnCgf31Gt1j/TWAAvxdGA8NDeaoVzEz8Z2VL12ej
eI/1GfqvIKQ23t7wCzibGiKgG+HT8Ij6zDgL9TU91+n8AOxDf3+hWY4nse5jzq1F
WkTmxMAdb3+COkzYPVh+u/s=
-----END PRIVATE KEY-----
EOF

cat > /etc/nginx/ssl/server.crt <<EOF
-----BEGIN CERTIFICATE-----
MIIDezCCAmOgAwIBAgIJAKyn7JJ79Dn3MA0GCSqGSIb3DQEBCwUAMFQxCzAJBgNV
BAYTAkZSMQwwCgYDVQQIDANJREYxDjAMBgNVBAcMBVBBUklTMRIwEAYDVQQKDAlD
bG91ZHdhdHQxEzARBgNVBAMMCm15LWxiLXRlc3QwHhcNMTUwNjI1MTEwMDMxWhcN
MTYwNjI0MTEwMDMxWjBUMQswCQYDVQQGEwJGUjEMMAoGA1UECAwDSURGMQ4wDAYD
VQQHDAVQQVJJUzESMBAGA1UECgwJQ2xvdWR3YXR0MRMwEQYDVQQDDApteS1sYi10
ZXN0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzC4Djt51XIkzAf/+
d0zjaIXgGkSEO9DZmx68M3cnH/8ky79g+Z62Bz+NBzyc9XXkfLZEzF9KJo1ZE0mR
ZNSP3wK2s918LQBhrElH2ZJy/cY7QgSzG6ne9tXvaPAxoVcvidSvhLaBTXB4odQm
iW4YN8oxx0KPmBM9nA/TLBKiLnT53dpfBOLqbGEO4t/W2AFLW18CtNcc9zlXTsXF
GjIFXLJ2zCW4o+qsRafCZcMaJaaDgqa2mtlPFM6EllHVDlg//Fg6ztPUWreJATPg
CrYpde4kSYPfiZ5/FdaNDjgmiaQPffGhZ7j0fxPOaYuNktnYM67Gq3pUNIImFzpK
/UUaYQIDAQABo1AwTjAdBgNVHQ4EFgQUv8qwQnlMc6hqYlZhHgFZk2eFyRUwHwYD
VR0jBBgwFoAUv8qwQnlMc6hqYlZhHgFZk2eFyRUwDAYDVR0TBAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAQEARGS59iGxYQTN3HLnQPpdui4dZ62jbcArjuZUht1Mnqoa
ODq3NlFP63MtPLZzJzTdW48TVbomyKHYudq114GLEbPULhPXiEpjwZoL8qYdSGCk
iJMgp03HgxDtrVruH/ffHUidPLtk11RC5pxXbVOEEq0clJRd2KFozCycrirVvnHq
QNrg8yMty+8zudvEaiG6mo48yb553ajk3E8RevuJQvQpBOPwVhslLghzyC9AXyTF
XszoYWXUIn5Xe2vfmB83GqHKJqPGw7ro5YtpmNLQDiuOuzbY0Jipj8skX32emS2K
NjqcbqS5uya2kXeGkUCZ8092FfNvizKUXiPmoNzTtA==
-----END CERTIFICATE-----
EOF
cat > /usr/share/nginx/html/index.html <<EOF
$(hostname)
EOF

cat > /etc/nginx/sites-available/default <<EOF
server {
        listen 80;

        listen 443 ssl;

        root /usr/share/nginx/html;
        index index.html index.htm;

        ssl_certificate /etc/nginx/ssl/server.crt;
        ssl_certificate_key /etc/nginx/ssl/server.key;

        location ~ \.php$ {
	        try_files $uri =404;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
	}

}
EOF

cat /etc/php5/fpm/php.ini > toto
sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' toto > /etc/php5/fpm/php.ini

cat > /usr/share/nginx/html/12345.php <<EOF
$(hostname)
<br>
<?php
phpinfo();
?>
EOF

cat > /usr/share/nginx/html/12345-headers.php <<EOF
$(hostname)
<br>
<?php
foreach($_SERVER as $h=>$v)
  if(ereg('HTTP_(.+)',$h,$hp))
    echo "<li>$h = $v</li>\n";
header('Content-type: text/html');

session_start();
echo session_id();
?>
EOF


service nginx restart
