module Py_stuff : sig
  type t

  val of_pyobject : Pytypes.pyobject -> t option

  val to_pyobject : t -> Pytypes.pyobject

  val whoa : a:int -> b:int -> unit -> int

  val cool : unit -> string
end = struct
  let filter_opt l = List.filter_map Fun.id l

  let py_module =
    lazy
      (let source =
         {pyml_bindgen_string_literal|#!/usr/bin/env python
import contextlib as __stickytape_contextlib

@__stickytape_contextlib.contextmanager
def __stickytape_temporary_dir():
    import tempfile
    import shutil
    dir_path = tempfile.mkdtemp()
    try:
        yield dir_path
    finally:
        shutil.rmtree(dir_path)

with __stickytape_temporary_dir() as __stickytape_working_dir:
    def __stickytape_write_module(path, contents):
        import os, os.path

        def make_package(path):
            parts = path.split("/")
            partial_path = __stickytape_working_dir
            for part in parts:
                partial_path = os.path.join(partial_path, part)
                if not os.path.exists(partial_path):
                    os.mkdir(partial_path)
                    with open(os.path.join(partial_path, "__init__.py"), "wb") as f:
                        f.write(b"\n")

        make_package(os.path.dirname(path))

        full_path = os.path.join(__stickytape_working_dir, path)
        with open(full_path, "wb") as module_file:
            module_file.write(contents)

    import sys as __stickytape_sys
    __stickytape_sys.path.insert(0, __stickytape_working_dir)

    __stickytape_write_module('mathy/add.py', b'def add(a, b):\n    return a + b\n')
    __stickytape_write_module('mathy/sub.py', b'def sub(a, b):\n    return a - b\n')
    __stickytape_write_module('sparkles/shimmer.py', b'def shine():\n    return "so shiny!"\n')
    from mathy.add import add
    from mathy.sub import sub
    from sparkles.shimmer import shine
    
    def whoa(a, b):
        x = add(a, b)
        y = sub(a, b)
        return x * y
    
    def cool():
        return shine()
    |pyml_bindgen_string_literal}
       in
       let filename =
         {pyml_bindgen_string_literal|interface_rollup.py|pyml_bindgen_string_literal}
       in
       let bytecode = Py.compile ~filename ~source `Exec in
       Py.Import.exec_code_module
         {pyml_bindgen_string_literal|interface|pyml_bindgen_string_literal}
         bytecode )
  let import_module () = Lazy.force py_module

  type t = Pytypes.pyobject

  let is_instance pyo =
    let py_class = Py.Module.get (import_module ()) "NA" in
    Py.Object.is_instance pyo py_class

  let of_pyobject pyo = if is_instance pyo then Some pyo else None

  let to_pyobject x = x

  let whoa ~a ~b () =
    let callable = Py.Module.get (import_module ()) "whoa" in
    let kwargs =
      filter_opt [Some ("a", Py.Int.of_int a); Some ("b", Py.Int.of_int b)]
    in
    Py.Int.to_int @@ Py.Callable.to_function_with_keywords callable [||] kwargs

  let cool () =
    let callable = Py.Module.get (import_module ()) "cool" in
    let kwargs = filter_opt [] in
    Py.String.to_string
    @@ Py.Callable.to_function_with_keywords callable [||] kwargs
end
