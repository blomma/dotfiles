import subprocess
import os.path
import commands

def op_passwd(item, field):
    cmd = """fish -c 'op_ "%s" "%s"'""" % (item, field)
    (status, output) = commands.getstatusoutput(cmd)
    return output.strip()

def imappasswd(account_name):
    path = os.path.expanduser('~/.offlineimap.password')
    if(account_name == "brf"):
        path = os.path.expanduser('~/.offlineimap.brf.password')
    args = ["cat", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
