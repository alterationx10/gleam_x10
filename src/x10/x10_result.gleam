import gleam/result

/// curried result.try that's ugly to use outside of a use expressions
pub fn use_try(r: Result(a, e)) -> fn(fn(a) -> Result(b, e)) -> Result(b, e) {
  result.try(r, _)
}

/// map_error and use_try
pub fn use_try_map_error(
  r: Result(a, e),
  with err_fn: fn(e) -> ee,
) -> fn(fn(a) -> Result(f, ee)) -> Result(f, ee) {
  r
  |> result.map_error(err_fn)
  |> use_try
}

/// replace_error and use_try
pub fn use_try_replace_error(
  r: Result(a, e),
  with error: ee,
) -> fn(fn(a) -> Result(g, ee)) -> Result(g, ee) {
  r
  |> result.replace_error(error)
  |> use_try
}
