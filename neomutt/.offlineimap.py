import subprocess
import os.path

def imappasswd(account_name):
    path = os.path.expanduser('~/.offlineimap.password')
    if(account_name == "secondary"):
        path = os.path.expanduser('~/.offlineimap.secondary.password')
    args = ["cat", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
