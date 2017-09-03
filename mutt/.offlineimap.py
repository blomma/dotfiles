import subprocess
import os.path

def imappasswd():
    path = os.path.expanduser('~/.offlineimap.password')
    args = ["openssl", "enc", "-d", "-aes-256-cbc", "-in", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
