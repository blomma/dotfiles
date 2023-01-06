set -gx HTTP_PROXY "http://10.32.16.10:8080"
set -gx HTTPS_PROXY "http://10.32.16.10:8080"
set -gx FTP_PROXY "http://10.32.16.10:8080"
set -gx NO_PROXY "localhost,127.0.0.1,.skandianet.org,.skandianordic.org,.ctx.skandia.se"

fish_add_path /home/linuxbrew/.linuxbrew/bin

# A fix for wonky dircolors on wsl
eval (dircolors -c ~/.config/fish/dircolors)
