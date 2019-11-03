# -*- coding: utf-8 -*-
"""Console script for happy_repo."""
import sys
import click
from happy_repo import simple_function


@click.command()
@click.option('--upper',
              type=bool,
              default=False,
              is_flag=True,
              flag_value=True)
@click.argument('string', type=str)
def main(upper, string):
    """Console script for happy_repo."""
    click.echo("Hello! This is Happy Repo")

    value = simple_function(string)

    sys.stdout.write(value.upper() if upper else value)

    return 0


if __name__ == "__main__":
    sys.exit(main())  # pragma: no cover
