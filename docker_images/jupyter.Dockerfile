FROM python:3.11-slim
RUN pip install --no-cache-dir jupyterlab pytest sphinx myst-parser jupyter-book
RUN useradd -m -s /bin/bash student || true
WORKDIR /home/student
EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''"]
