#! /usr/bin/env python
import os
import subprocess

import click


def run_bash_with_env(env_updates, bash_command, replace_current_process=True):
    env = os.environ.copy()
    env.update(env_updates)
    tokens = bash_command.split()
    if replace_current_process:
        os.execvpe(tokens[0], tokens, env)
    else:
        subprocess.run(tokens, env=env)


@click.command()
def main():
    env_updates = {}
    run_bash_with_env(env_updates, "pgcli")


if __name__ == "__main__":
    main()

