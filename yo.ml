let () = Py.initialize ()

let () = Format.printf "Whoa!? %d\n" @@ Utils.Py_stuff.whoa ~a:10 ~b:20 ()

let () = Format.printf "Cool!! %s\n" @@ Utils.Py_stuff.cool ()
