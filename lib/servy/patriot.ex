defmodule Servy.Patriot do
  
  defstruct id: nil, name: "", type: "", injured_reserve: false

  def is_safety(patriot) do
    patriot.type == 'Safety'
  end

  def order_asc_by_name(p1, p2) do
    p1.name <= p2.name
  end
end