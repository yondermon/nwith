defmodule Nwith do
  @moduledoc """
  Documentation for Nwith.
  """

  @doc ~S"""
  Named `with`. Just like `with`.

  ## Examples

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

  """
  defmacro nwith(clauses, do: expression, else: else_clauses) do
    nwith_else(
      Macro.expand(else_clauses, __CALLER__),
      nwith_each(
        Macro.expand(clauses, __CALLER__),
        Macro.expand(expression, __CALLER__)
      )
    )
  end

  defmacro nwith(clauses, do: expression) do
    expr =
      nwith_each(
        Macro.expand(clauses, __CALLER__),
        Macro.expand(expression, __CALLER__)
      )

    quote do
      case unquote(expr) do
        {:nwith_clause_error, {_key, error}} -> error
        rest -> rest
      end
    end
  end

  defp nwith_each([], expr), do: expr

  defp nwith_each([{key, {:<-, _scope, [expr1, expr2]}} | tail], expr) do
    nested = nwith_each(tail, expr)

    quote do
      case {unquote(key), unquote(expr2)} do
        {key, unquote(expr1)} ->
          unquote(nested)

        otherwise ->
          {:nwith_clause_error, otherwise}
      end
    end
  end

  defp nwith_else(clauses, result) do
    {:case, [],
     [
       result,
       [
         do: nwith_else_to_case_items(clauses)
       ]
     ]}
  end

  defp nwith_else_to_case_items([]),
    do: [
      {:->, [],
       [
         [{:nwith_clause_error, {:error, [], Nwith}}],
         {:raise, [context: Nwith, import: Kernel],
          [
            {:__aliases__, [alias: false], [:NwithClauseError]},
            [
              message:
                {:<<>>, [],
                 [
                   "no nwith clause matching: ",
                   {:"::", [],
                    [
                      {{:., [], [Kernel, :to_string]}, [],
                       [
                         {:inspect, [context: Nwith, import: Kernel], [{:error, [], Nwith}]}
                       ]},
                      {:binary, [], Nwith}
                    ]}
                 ]}
            ]
          ]}
       ]},
      {:->, [],
       [
         [{:ok, [], Nwith}],
         {:ok, [], Nwith}
       ]}
    ]

  defp nwith_else_to_case_items([{:->, scope, [[[{key, clause}]], expr]} | tail]) do
    [
      {:->, scope, [[{:nwith_clause_error, {key, clause}}], expr]}
      | nwith_else_to_case_items(tail)
    ]
  end
end
