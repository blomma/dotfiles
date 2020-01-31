import subprocess
import os.path
import commands


def get_pass(account_name):
    cmd = """gpg -dq ~/.config/offlineimap/%s.gpg""" % (account_name)
    return subprocess.check_output(cmd, shell=True).strip("\n")


def op_passwd(item, field):
    cmd = """fish -c 'op_ "%s" "%s"'""" % (item, field)
    (status, output) = commands.getstatusoutput(cmd)
    return output.strip()


def password(account_name):
    ppath = """~/.offlineimap.%s.password""" % (account_name)
    path = os.path.expanduser(ppath)
    args = ["cat", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""
