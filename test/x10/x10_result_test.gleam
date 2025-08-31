import gleam/result
import gleeunit
import x10
import x10/x10_result

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn use_try_test() {
  // gleam test
  assert result.try(Error(1), fn(x) { Ok(x + 1) }) == Error(1)
  // comparable
  assert { Error(1) |> x10_result.use_try }(fn(x) { Ok(x + 1) }) == Error(1)

  // gleam test
  assert result.try(Ok(1), fn(x) { Ok(x + 1) }) == Ok(2)
  // comparable
  assert { Ok(1) |> x10_result.use_try }(fn(x) { Ok(x + 1) }) == Ok(2)

  // gleam test
  assert result.try(Ok(1), fn(_) { Ok("type change") }) == Ok("type change")
  // comparable
  assert { Ok(1) |> x10_result.use_try }(fn(_) { Ok("type change") })
    == Ok("type change")

  // gleam test
  assert result.try(Ok(1), fn(_) { Error(1) }) == Error(1)
  // comparable
  assert { Ok(1) |> x10_result.use_try }(fn(_) { Error(1) }) == Error(1)
}

type TestError {
  ErrorMsg(msg: String)
  ErrorCode(code: Int)
}

pub fn use_try_wrap_error_test() {
  assert {
      Error(1)
      |> x10_result.use_try_map_error(fn(e) { ErrorCode(e) })
    }(Ok)
    == Error(ErrorCode(1))

  assert {
      Ok(1)
      |> x10_result.use_try_map_error(fn(e) { ErrorCode(e) })
    }(Ok)
    == Ok(1)

  assert {
      Ok(1)
      |> x10_result.use_try_map_error(fn(e) { ErrorCode(e) })
    }(fn(x) { Ok(x + 1) })
    == Ok(2)

  assert {
      Error(1)
      |> x10_result.use_try_map_error(fn(_) { ErrorMsg("type change") })
    }(Ok)
    == Error(ErrorMsg("type change"))

  assert {
      Ok(1)
      |> x10_result.use_try_map_error(fn(_) { ErrorMsg("type change") })
    }(Ok)
    == Ok(1)

  assert {
      Error(1)
      |> x10_result.use_try_map_error(x10.identity)
    }(Ok)
    == Error(1)
}

pub fn use_try_replace_error_test() {
  assert {
      Ok(1)
      |> x10_result.use_try_replace_error(ErrorCode(2))
    }(Ok)
    == Ok(1)

  assert {
      Error("oh no")
      |> x10_result.use_try_replace_error(ErrorCode(2))
    }(Ok)
    == Error(ErrorCode(2))
}
