function check_tls
    msmtp --serverinfo --tls --tls-certcheck=off -a blomma
    # msmtp --serverinfo --tls --tls-certcheck=off -a mother
    echo "mail.messagingengine.com"
    echo | openssl s_client -connect mail.messagingengine.com:993 &| openssl x509 -fingerprint -noout -sha512
end
