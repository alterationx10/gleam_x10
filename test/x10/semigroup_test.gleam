import gleeunit
import x10/semigroup

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn int_semigroup_test() {
  assert semigroup.int_semigroup.combine(2, 3) == 5
}

pub fn string_semigroup_test() {
  assert semigroup.string_semigroup.combine("abc", "123") == "abc123"
}

pub fn string_result_semigroup_test() {
  assert semigroup.string_result_semigroup.combine(Ok("abc"), Ok("123"))
    == Ok("abc123")

  assert semigroup.string_result_semigroup.combine(Error(42), Ok("123"))
    == Error(42)

  assert semigroup.string_result_semigroup.combine(Ok("abc"), Error("123"))
    == Error("123")
}

pub fn semigroup_fold_list_test() {
  let ints = [1, 2, 3, 4, 5]

  assert semigroup.semigroup_fold_list(ints, 0, semigroup.int_semigroup) == 15
}
