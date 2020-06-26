# Nwith

This library provides `nwith` macro for named fallbacks of `with`-like clauses.

## Installation

The package can be installed as:

  1. Add exiban to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:nwith, "~> 0.1.0"}]
    end
    ```

  2. Run `mix deps.get` in your console to fetch from Hex


## Usage

```elixir
iex> import Nwith, only: [nwith: 2]
iex> nwith firstly: {:ok, value} = result <- {:ok, true},
...>       secondly: true <- value,
...>       finally: {:ok, true} <- result do
...>   "The result is " <> inspect(result)
...> else
...>   secondly: false ->
...>     "Not gonna happen"
...>
...>   secondly: nil ->
...>     "Just nothing"
...>
...>   finally: error ->
...>     "Something went wrong: #{inspect(error)}"
...> end
"The result is {:ok, true}"
```

## License

Nwith source code is released under Apache 2 License.

Check the [LICENSE](LICENSE) file for more information.
