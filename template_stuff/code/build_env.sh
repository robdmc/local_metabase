#! /usr/bin/env bash

rm -rf /env/*
python -m venv /env/base
/env/base/bin/pip install -U pip
/env/base/bin/pip install -r /code/requirements.txt
