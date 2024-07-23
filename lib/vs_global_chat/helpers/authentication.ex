defmodule VsGlobalChat.Helpers.Authentication do

  require Logger
  import Ecto.Query
  alias VsGlobalChat.{Repo, User}

  @doc false
  def try_login(uid, auth_token) do
    case Repo.one(from u in User, where: u.uid == ^uid and u.auth_token == ^auth_token) do
      %User{} = user -> authenticate_administrator(user)
      _ -> false
    end

  end

  def authenticate_administrator(%User{} = user) do
    if user.permissions == :administrator do
      true
    else
      false
    end
  end

end
