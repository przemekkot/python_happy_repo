#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""The setup script."""
import os
from setuptools import setup, find_packages

__folder__ = os.path.abspath(os.path.dirname(__file__))

with open(os.path.join(__folder__,'.version')) as version_file:
    version = version_file.read().strip()

with open('README.rst') as readme_file:
    readme = readme_file.read()

with open('HISTORY.rst') as history_file:
    history = history_file.read()

requirements = ['Click>=7.0', ]

setup_requirements = ['pytest-runner', ]

test_requirements = ['pytest>=3', ]

setup(
    author="Oren Kot",
    author_email='przemyslaw.kot@gmail.com',
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],
    description="This is a test range package. This will be destroyed and everything in it.",
    entry_points={
        'console_scripts': [
            'happy_repo=happy_repo.cli:main',
        ],
    },
    install_requires=requirements,
    license="MIT license",
    long_description=readme + '\n\n' + history,
    include_package_data=True,
    keywords='happy_repo',
    name='happy_repo',
    packages=find_packages(include=['happy_repo', 'happy_repo.*']),
    setup_requires=setup_requirements,
    test_suite='tests',
    tests_require=test_requirements,
    url='https://github.com/orenkot/happy_repo',
    version=version,
    zip_safe=False,
)
