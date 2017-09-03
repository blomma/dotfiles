import subprocess
import os.path

# Generate password with openssl enc -aes-256-cbc -in password.txt  -out .offlineimap.password
def imappasswd():
    path = os.path.expanduser('~/.offlineimap.password')
    args = ["cat", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
