import subprocess


def get_pass(account_name):
    cmd = """gpg -dq ~/.secure/%s.gpg""" % (account_name)
    return subprocess.check_output(cmd, shell=True)
