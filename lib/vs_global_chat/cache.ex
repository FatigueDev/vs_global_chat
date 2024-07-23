defmodule VsGlobalChat.Cache do
  @moduledoc false

  alias Cachex
  alias VsGlobalChat.{Repo, User, Message}

  def cache_name, do: __MODULE__
  def users_key, do: :users
  def messages_key, do: :messages

  def to_auth_key(remote_ip), do: "is_authorized:" <> remote_ip

  def put_auth(remote_ip, expires_in \\ :timer.hours(1)) do
    put(to_auth_key(remote_ip), true)
    expire(to_auth_key(remote_ip), expires_in)
  end

  def put(key, value), do: Cachex.put(cache_name(), key, value)

  @spec get(any()) :: {atom(), any()}
  def get(key), do: Cachex.get(cache_name(), key)

  def expire(key, expires_in) do
    Cachex.expire(cache_name(), key, expires_in)
  end

end
