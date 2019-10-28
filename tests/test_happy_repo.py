#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Tests for `happy_repo` package."""

import pytest

from click.testing import CliRunner

from happy_repo import happy_repo
from happy_repo import cli


@pytest.fixture
def response():
    """Sample pytest fixture.

    See more at: http://doc.pytest.org/en/latest/fixture.html
    """
    # import requests
    # return requests.get('https://github.com/audreyr/cookiecutter-pypackage')


def test_content(response):
    """Sample pytest test function with the pytest fixture as an argument."""
    # from bs4 import BeautifulSoup
    # assert 'GitHub' in BeautifulSoup(response.content).title.string


def test_command_line_interface():
    """Test the CLI."""
    runner = CliRunner()
    result = runner.invoke(cli.main, ['ryba'])
    assert result.exit_code == 0
    assert 'Hello! This is Happy Repo' in result.output
    assert 'ryba' in result.output

    help_result = runner.invoke(cli.main, ['--help'])
    assert help_result.exit_code == 0
    assert "--help   Show this message and exit." in str(help_result.output)

    runner = CliRunner()
    result = runner.invoke(cli.main, [
        '--upper',
        'ryba',
    ])
    assert result.exit_code == 0
    assert 'Hello! This is Happy Repo' in result.output
    assert 'ryba' in result.output
    assert 'RYBA' in result.output


def test_simple_function():
    """Test a simple function"""

    function = happy_repo.simple_function

    assert 'cow' == function('cow')
    assert '' == function('')
    assert 0 == function(0)
    assert 3 == function(3)
    assert None is function(None)
