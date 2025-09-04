pub opaque type Lazy(a, e) {
  Fn(computation: fn() -> Result(a, e))
  Fail(error: e)
  Recover(lzy: Lazy(a, e), error_fn: fn(e) -> Lazy(a, e))
  Bind(cont: fn() -> Result(a, e))
  Retry(lzy: Lazy(a, e), at_most: Int)
}

pub fn lzy(f: fn() -> Result(a, e)) {
  Fn(f)
}

pub fn flat_map(lzy: Lazy(a, e), f: fn(a) -> Lazy(b, e)) -> Lazy(b, e) {
  Bind(fn() {
    case run(lzy) {
      Ok(value) -> run(f(value))
      Error(e) -> Error(e)
    }
  })
}

pub fn map(lzy: Lazy(a, e), f: fn(a) -> b) -> Lazy(b, e) {
  flat_map(lzy, fn(x) { pure(f(x)) })
}

pub fn pure(value: a) -> Lazy(a, e) {
  Fn(fn() { Ok(value) })
}

pub fn pure_error(error: e) -> Lazy(a, e) {
  Fn(fn() { Error(error) })
}

pub fn fail(_: Lazy(a, e), e: e) -> Lazy(a, e) {
  Fail(e)
}

pub fn recover(lzy: Lazy(a, e), error_fn: fn(e) -> Lazy(a, e)) -> Lazy(a, e) {
  Recover(lzy, error_fn)
}

pub fn map_error(lzy: Lazy(a, e1), f: fn(e1) -> e2) -> Lazy(a, e2) {
  Bind(fn() {
    case run(lzy) {
      Ok(value) -> Ok(value)
      Error(error) -> Error(f(error))
    }
  })
}

pub fn retry_n(lzy: Lazy(a, e), max_attempts: Int) -> Lazy(a, e) {
  Retry(lzy, max_attempts)
}

pub fn or_else(lzy: Lazy(a, e), default: Lazy(a, e)) -> Lazy(a, e) {
  lzy
  |> recover(fn(_) { default })
}

pub fn or_else_value(lzy: Lazy(a, e), default: a) -> Lazy(a, e) {
  lzy
  |> recover(fn(_) { pure(default) })
}

pub fn as_result(lzy: Lazy(a, e), result: b) -> Lazy(b, e) {
  lzy
  |> flat_map(fn(_) { pure(result) })
}

pub fn nil(lzy: Lazy(a, e)) -> Lazy(Nil, e) {
  lzy
  |> map(fn(_) { Nil })
}

pub fn ignore(lzy: Lazy(a, e)) -> Lazy(Nil, Nil) {
  lzy
  |> nil
  |> map_error(fn(_) { Nil })
  |> recover(fn(_) { pure(Nil) })
}

pub fn run(lzy: Lazy(a, e)) -> Result(a, e) {
  case lzy {
    Fn(computation) -> computation()
    Fail(error) -> Error(error)
    Recover(inner, error_fn) -> {
      case run(inner) {
        Ok(value) -> Ok(value)
        Error(error) -> run(error_fn(error))
      }
    }
    Bind(cont) -> cont()
    Retry(inner, count) -> {
      case run(inner) {
        Ok(value) -> Ok(value)
        Error(_) if count > 1 -> run(Retry(inner, count - 1))
        Error(error) -> Error(error)
      }
    }
  }
}
