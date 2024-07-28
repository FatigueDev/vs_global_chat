defmodule VsGlobalChatProto.Payload do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :Module, 1, type: :string
  field :Event, 2, type: :string
  field :PacketType, 3, type: :string
  field :PacketValue, 4, type: :bytes
end