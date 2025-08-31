import gleeunit
import x10

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn identity_test() {
  assert x10.identity(42) == 42
  assert x10.identity("42") == "42"
  let add_one = fn(x) { x + 1 }
  assert x10.identity(add_one) == add_one
}
