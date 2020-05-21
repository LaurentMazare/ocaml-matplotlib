all:
	dune build @install

plot: .FORCE
	dune build examples/pyplot.exe
	_build/default/examples/pyplot.exe

clean:
	rm -Rf _build

.FORCE:
