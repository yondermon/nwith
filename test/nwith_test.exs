defmodule NwithTest do
  use ExUnit.Case
  import Nwith, only: [nwith: 2]

  doctest Nwith

  test "nwith handled failure case" do
    nwith_result =
      nwith check: {:ok, "string"} <- {:ok, true} do
        "Success"
      else
        check: {:error, error} ->
          "An error occurred: #{inspect(error)}"

        check: error ->
          "Something went wrong: #{inspect(error)}"
      end

    assert "Something went wrong: {:ok, true}" == nwith_result
  end

  test "nwith unhandled failure" do
    assert_raise NwithClauseError, fn ->
      nwith check: true <- nil do
        "True"
      else
        check: false ->
          "False"
      end
    end
  end

  test "nwith without else statement" do
    nwith_result =
      nwith check: {:ok, "string"} <- {:ok, true} do
        "Success"
      end

    assert {:ok, true} == nwith_result
  end
end
