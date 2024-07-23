defmodule VsGlobalChatProto.CreateMessage do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :sender, 1, type: :string
  field :message, 2, type: :string
end