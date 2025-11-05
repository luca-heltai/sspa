build:
	. ./start.sh && cd jupyterbook && jupyter book build --html

clean:
	. ./start.sh && cd jupyterbook && jupyter book clean -y

serve:
	. ./start.sh && cd jupyterbook/_build/html && python -m http.server 3001

start:
	. ./start.sh && cd jupyterbook && jupyter book start

link: 
	echo Linking slides
	rm -rf `pwd`/jupyterbook/_build/html/slideshow/
	ln -s `pwd`/jupyterbook/slides `pwd`/jupyterbook/_build/html/slideshow

copy: 
	echo Copying slides
	rm -f `pwd`/jupyterbook/_build/html/slideshow
	cp -r `pwd`/jupyterbook/slides `pwd`/jupyterbook/_build/html/slideshow

.PHONY: build clean serve start link copy
