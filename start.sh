#!/bin/sh
if [ -d ~/anaconda3/bin ]; then
  # Prefer Anaconda3 Python if available
  echo "Anaconda3 found."
  export PATH=~/anaconda3/bin:$PATH
fi
if [ ! -d env ]; then 
  python3 -m pip install --user virtualenv
  python3 -m venv env
  source ./env/bin/activate
  if [ -f requirements.txt ]; then
    echo "Installing required packages from requirements.txt"
  else
    echo "requirements.txt not found! Creating a default one."
    echo "jupyter-book>=2.0.0" > requirements.txt
  fi
  python3 -m pip install -r requirements.txt
else
  echo "env directory already exists. Sourcing the virtual environment."
  source ./env/bin/activate
fi
