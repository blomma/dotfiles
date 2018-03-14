set -l LOCAL_CONFIG "$HOME/.config/fish"
set -l host (hostname | sed -E 's/(-[0-9]+)?(\.(local|home))?$//' | tr '[:upper:]' '[:lower:]')
set -l user (whoami | tr '[:upper:]' '[:lower:]')
set -l platform (uname -s | tr '[:upper:]' '[:lower:]')

# Load custom settings for current hostname
set -l host_specific_file $LOCAL_CONFIG/hosts/$host.fish
if test -f $host_specific_file
  source $host_specific_file
else
  echo Creating host specific config file: $host_specific_file
  mkdir -p (dirname $host_specific_file)
  touch $host_specific_file
end

# Load custom settings for current user
set -l user_specific_file $LOCAL_CONFIG/users/$user.fish
if test -f $user_specific_file
  source $user_specific_file
else
  echo Creating user specific config file: $user_specific_file
  mkdir -p (dirname $user_specific_file)
  touch $user_specific_file
end

# Load custom settings for current OS
set -l platform_specific_file $LOCAL_CONFIG/platforms/$platform.fish
if test -f $platform_specific_file
  source $platform_specific_file
else
  echo Creating platform specific config file: $platform_specific_file
  mkdir -p (dirname $platform_specific_file)
  touch $platform_specific_file
end