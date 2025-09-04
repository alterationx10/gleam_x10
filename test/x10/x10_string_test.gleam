import gleam/dict
import gleeunit
import x10/x10_string

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn template_full_test() {
  assert x10_string.template_full(
      "Hello, $[0]. It's $[1]",
      ["you", "me"],
      "$[",
      "]",
    )
    == "Hello, you. It's me"

  assert x10_string.template_full(
      "Hello, $[0]. It's $[1], $[0]!",
      ["you", "me"],
      "$[",
      "]",
    )
    == "Hello, you. It's me, you!"
}

pub fn template_test() {
  assert x10_string.template("Hello, ${0}. It's ${1}", ["you", "me"])
    == "Hello, you. It's me"

  assert x10_string.template("Hello, ${0}. It's ${1}, ${0}!", ["you", "me"])
    == "Hello, you. It's me, you!"
}

pub fn template_dict_full_test() {
  let args =
    dict.new()
    |> dict.insert("name", "you")
    |> dict.insert("greeter", "me")

  assert x10_string.template_dict_full(
      "Hello, $[name]. It's $[greeter]",
      args,
      "$[",
      "]",
    )
    == "Hello, you. It's me"

  assert x10_string.template_dict_full(
      "Hello, $[name]. It's $[greeter], $[name]!",
      args,
      "$[",
      "]",
    )
    == "Hello, you. It's me, you!"
}

pub fn template_dict_test() {
  let args =
    dict.new()
    |> dict.insert("name", "you")
    |> dict.insert("greeter", "me")

  assert x10_string.template_dict("Hello, ${name}. It's ${greeter}", args)
    == "Hello, you. It's me"

  assert x10_string.template_dict(
      "Hello, ${name}. It's ${greeter}, ${name}!",
      args,
    )
    == "Hello, you. It's me, you!"
}
