function check_tls
    msmtp --serverinfo --tls --tls-certcheck=off -a blomma
    msmtp --serverinfo --tls --tls-certcheck=off -a mother
end