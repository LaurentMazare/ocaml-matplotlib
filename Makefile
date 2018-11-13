all:
	dune build @install

plot: .FORCE
	dune build examples/plot.exe
	_build/default/examples/plot.exe

clean:
	rm -Rf _build

.FORCE:
