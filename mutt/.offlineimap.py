import subprocess
import os.path

def imappasswd():
    path = os.path.expanduser('~/.offlineimap.password')
    args = ["cat", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
