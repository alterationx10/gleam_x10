import gleam/result

/// curried result.try
pub fn try(r: Result(_, _)) -> fn(fn(b) -> Result(c, d)) -> Result(c, d) {
  result.try(r, _)
}

/// map_error and lift into a try
pub fn try_wrap_error(r: Result(a, e), with err_fn: fn(e) -> ee) {
  r
  |> result.map_error(err_fn)
  |> try
}
