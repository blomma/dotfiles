echo "<PASSWORD>" > password
openssl enc -aes-256-cbc -in password  -out .offlineimap.password
