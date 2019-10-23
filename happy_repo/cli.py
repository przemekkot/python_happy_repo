# -*- coding: utf-8 -*-

"""Console script for happy_repo."""
import sys
import click
from happy_repo import simple_function

@click.command()
@click.option('--upper', type=bool, default=False, is_flag=True, flag_value=True)
@click.argument('string', type=str)
def main(upper, string):
    """Console script for happy_repo."""
    click.echo("Replace this message by putting your code into "
               "happy_repo.cli.main")
    click.echo("See click documentation at https://click.palletsprojects.com/")

    value = simple_function(string)

    sys.stdout.write(value.upper() if upper else value)

    return 0


if __name__ == "__main__":
    sys.exit(main())  # pragma: no cover
