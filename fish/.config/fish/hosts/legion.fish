test -d /home/linuxbrew/.linuxbrew/bin; and set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH
umask 022

set -gx LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib64
set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig

