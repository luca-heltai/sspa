build:
	. ./start.sh && cd jupyterbook && jupyter book build --html

clean:
	. ./start.sh && cd jupyterbook && jupyter book clean -y

serve:
	make build && \
	make link && \
	. ./start.sh && cd jupyterbook/_build/html && python -m http.server 3001

start:
	. ./start.sh && cd jupyterbook && jupyter book start

link: 
	echo Linking slides
	rm -rf `pwd`/jupyterbook/_build/html/slideshow
	ln -s `pwd`/jupyterbook/slides `pwd`/jupyterbook/_build/html/slideshow

copy: 
	echo Copying slides
	rm -f `pwd`/jupyterbook/_build/html/slideshow
	cp -r `pwd`/jupyterbook/slides `pwd`/jupyterbook/_build/html/slideshow

slides:
	./codes/lab01/generate_slides.sh -v

all: build slides copy

.PHONY: build clean serve start link copy slides all

