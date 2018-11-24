function generate_rsa_without_pass --argument-names name
	ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/$name -q -N ""
end
