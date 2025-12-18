FROM texlive/texlive:latest

WORKDIR /work
COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

CMD ["latexmk", "-pdf", "-interaction=nonstopmode", "main.tex"]
