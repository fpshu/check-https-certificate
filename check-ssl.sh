#!/bin/bash
# check https certificate expire time
# v1.0
# created by TaPe
# requirements openssl, bc
################################

# current date in GMT
curdate=`LANG=en_US TZ=GMT date "+%b %e %T %Y %Z"`
# current date in GMT, seconds
curdates=`date -d "$curdate" +"%s"`

echo current date: $curdate
echo "###########################################################"
# checked https domains in bash array format
domains=( "example1.com" "example2.com" )

for i in "${domains[@]}"
do
	# get https certificate (support SNI) validity date
	certdate=`echo | openssl s_client -servername $i -connect $i:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d'=' -f 2`
	# get https certificate (support SNI) validity date in seconds
	certdates=`date -d "$certdate" +"%s"`

	echo $i expires: $certdate
	# print out the 2 date difference in seconds and format to days
	echo `echo "( $certdates - $curdates ) / ( 60 * 60 * 24 )" | bc` days left
	echo "###########################################################"

done
