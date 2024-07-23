defmodule VsGlobalChat.Helpers.Time do

  use Timex
  alias Ecto

  def time_relative(%DateTime{} = creation_date) do
    {:ok, time_ago} = Timex.format(creation_date, "{relative}", :relative)
    time_ago
  end

end
