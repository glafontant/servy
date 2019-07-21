defmodule Servy.Patriot do
  # TODO: It would be nice to specify attributes
  @derive [Poison.Encoder]
  defstruct id: nil, name: "", type: "", injured_reserve: false

  def is_safety(patriot) do
    patriot.type == 'Safety'
  end

  def order_asc_by_id(p1, p2) do
    p1.id <= p2.id
  end
end