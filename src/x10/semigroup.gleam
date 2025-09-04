import gleam/int
import gleam/list
import gleam/string
import x10/x10_result

pub type Semigroup(a) {
  Semigroup(combine: fn(a, a) -> a)
}

pub const int_semigroup: Semigroup(Int) = Semigroup(combine: int.add)

pub const string_semigroup: Semigroup(String) = Semigroup(
  combine: string.append,
)

fn generic_result_combine(
  x: Result(a, e),
  y: Result(a, e),
  combiner: Semigroup(a),
) -> Result(a, e) {
  use xx <- x |> x10_result.use_try
  use yy <- y |> x10_result.use_try
  Ok(combiner.combine(xx, yy))
}

fn string_resut_combine(
  a: Result(String, e),
  b: Result(String, e),
) -> Result(String, e) {
  generic_result_combine(a, b, string_semigroup)
}

pub const string_result_semigroup: Semigroup(Result(String, b)) = Semigroup(
  combine: string_resut_combine,
)

pub fn semigroup_fold_list(
  list: List(a),
  initial i: a,
  combiner sg: Semigroup(a),
) -> a {
  list
  |> list.fold(i, fn(acc, e) { sg.combine(acc, e) })
}
