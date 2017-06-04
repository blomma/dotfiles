import subprocess

def imappasswd():
    args = ["/usr/bin/security", "find-internet-password", "-a", "user@example.com", "-s", "mail.messagingengine.com", "-r", "imap", "-w"]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
