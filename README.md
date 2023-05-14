# Stickytape + pyml_bindgen

One solution to [this](https://github.com/mooreryan/ocaml_python_bindgen/issues/10) issue on [pyml_bindgen](https://github.com/mooreryan/ocaml_python_bindgen) GitHub.

Essentially, it is a way to embed multiple Python files/modules into your OCaml executable.

The `py` directory has some Python code.  Two modules `mathy` and `sparkles`, with submodules.  `interface.py` depends on both of them, and that is the file we want to generate bindings for with `pyml_bindgen`.

The problem is that we don't want to have to have the user of our OCaml program care about installing these modules we made.  We want it all embedded.  So the [stickytape](https://github.com/mwilliamson/stickytape) program is used to generate one python script with machinery to "roll up" everything needed into one file.  Then this rolled up file is embedded in the OCaml code for pyml to use.

Checkout the `dune` file for the shell commands needed to set this all up.

Run the executable with `dune exec ./yo.exe` and the tests with `dune runtest`.  After you build, feel free to move the generated executable to another directory, or another machine, it will work fine!

## License

<a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
<img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
</a>

To the extent possible under law, Ryan M. Moore has waived all copyright and related or neighboring rights to this project.

_If for whatever reason, CC0 will not work for your project, you may use MIT or the Unlicense._
