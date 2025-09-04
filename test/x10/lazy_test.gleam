import gleeunit
import x10/lazy

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn lzy_test() {
  assert lazy.lzy(fn() { Ok(1) })
    |> lazy.run
    == Ok(1)

  assert lazy.lzy(fn() { Error(1) })
    |> lazy.run
    == Error(1)
}

pub fn map_test() {
  assert lazy.lzy(fn() { Ok(1) })
    |> lazy.map(fn(i) { i + 1 })
    |> lazy.run
    == Ok(2)

  assert lazy.lzy(fn() { Error(1) })
    |> lazy.map(fn(i) { i + 1 })
    |> lazy.run
    == Error(1)
}
// TODO the rest of the ~Owl~ tests...
