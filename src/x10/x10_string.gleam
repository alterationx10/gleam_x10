import gleam/int
import gleam/list
import gleam/string_tree

/// Replace index-based open/closed portions of a templates string with the args elements
/// e.g. template_full("Hello, $[0]! This is $[1]", ["you", "me", "$[", "]"]
/// -> "Hello, you! This is me"
pub fn template_full(
  str: String,
  args: List(String),
  open: String,
  close: String,
) -> String {
  let tmpl = string_tree.from_string(str)
  args
  |> list.index_fold(tmpl, fn(a, e, i) {
    let to_replace = open <> int.to_string(i) <> close
    string_tree.replace(a, to_replace, e)
  })
  |> string_tree.to_string
}

/// Replace ${index-based} portions of a templates string with the args elements,
/// This uses template_full with the open / close set to "${" / "}"
/// e.g. template("Hello, ${0}! This is ${1}", ["you", "me"]
/// -> "Hello, you! This is me
pub fn template(str: String, args: List(String)) -> String {
  template_full(str, args, "${", "}")
}
