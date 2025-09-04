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
