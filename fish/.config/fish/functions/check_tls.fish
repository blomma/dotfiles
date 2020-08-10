function check_tls
    msmtp --serverinfo --tls --tls-certcheck=off -a default
    msmtp --serverinfo --tls --tls-certcheck=off -a work
end