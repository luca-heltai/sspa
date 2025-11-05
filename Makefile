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
	rm -f `pwd`/jupyterbook/_build/html/slides/*.{html,md}
	ln -s `pwd`/jupyterbook/slides/*.{html,md} `pwd`/jupyterbook/_build/html/slides/

copy: 
	echo Copying slides
	rm -f `pwd`/jupyterbook/_build/html/slides/*.{html,md}
	cp -r `pwd`/jupyterbook/slides/*.{html,md} `pwd`/jupyterbook/_build/html/slides/

.PHONY: build clean serve start link copy
