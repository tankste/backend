defmodule Tankste.Sponsor.Balances do
  import Ecto.Query, warn: false

  alias Tankste.Sponsor.Balances.Balance
  alias Tankste.Sponsor.Transactions

  def get() do
    transactions = Transactions.list()
    spent_fixed = transactions |> Enum.filter(fn t -> t.value < 0  and t.category == "fixed" end) |> Enum.map(fn t -> t.value end) |> Enum.sum()
    spent_variable = transactions |> Enum.filter(fn t -> t.value < 0 and t.category == "variable" end) |> Enum.map(fn t -> t.value end) |> Enum.sum()
    earned = transactions |> Enum.filter(fn t -> t.value >= 0 end) |> Enum.map(fn t -> t.value end) |> Enum.sum()

    %Balance{
      earned: abs(earned * 1.0),
      spent_fixed: abs(spent_fixed * 1.0),
      spent_variable: abs(spent_variable * 1.0),
      balance: (earned + spent_fixed + spent_variable) * 1.0
    }
  end
end
