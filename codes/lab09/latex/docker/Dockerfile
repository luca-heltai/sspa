FROM texlive/texlive:latest

WORKDIR /work
COPY . .

CMD ["latexmk", "-pdf", "-interaction=nonstopmode", "main.tex"]
