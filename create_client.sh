new_client () {
	# Generates the custom client.ovpn
	{
	cat /etc/openvpn/server/client-common.txt
	#echo "<ca>"
	cat /etc/openvpn/server/easy-rsa/pki/ca.crt
	#echo "</ca>"
	#echo "<cert>"
	sed -ne '/BEGIN CERTIFICATE/,$ p' /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt
	#echo "</cert>"
	#echo "<key>"
	cat /etc/openvpn/server/easy-rsa/pki/private/"$client".key
	#echo "</key>"
	#echo "<tls-crypt>"
	sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/server/tc.key
	#echo "</tls-crypt>"
	} > /home/moomoo/"$client".ovpn
}
name=1
client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$name")
while [[ -z "$client" || -e /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt ]]; do
	#echo "$client: invalid name."
	name=$((name + 1))
	client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$name")
done
cd /etc/openvpn/server/easy-rsa/
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full "$client" nopass
# Generates the custom client.ovpn
new_client
#echo
#echo "$client added. Configuration available in:" /home/moomoo/"$client.ovpn"
echo "$client"
	exit
	;;