# defmodule VsGlobalChatWeb.Plug.Authorization do
#   @moduledoc """
#   Reads a user_details cookie and puts user_details into session
#   """
#   require Logger
#   import Plug.Conn
#   import Plug.BasicAuth
#   # import VsGlobalChat.Helpers.User
#   # alias Calendar.TimeZoneDatabase
#   alias VsGlobalChat.User
#   # import VsGlobalChat.Helpers.LiveView

#   def init(_) do
#     %{}
#   end

#   def call(conn, _opts) do
#     case parse_basic_auth(conn) do
#       {uid, token} ->
#         # Logger.info("A conn is trying to connect to the site:\nUID: #{uid}\nToken: #{token}\nConn:\n #{log_conn(conn)}", %{conn: log_conn(conn), uid: uid, token: token});
#         conn |> try_auth(uid, token)
#       :error ->
#         conn |> request_basic_auth() |> halt()
#     end
#   end

#   # defp log_conn(conn) do
#   #   """
#   #   {
#   #     method: #{conn.method},
#   #     user_agent: #{Plug.Conn.get_req_header(conn, "user-agent")},
#   #     conn_data:
#   #     {
#   #       port: #{conn.port}
#   #       address: #{get_remote_ip(conn)}
#   #     }
#   #   }
#   #   """
#   # end

#   defp try_auth(conn, uid, token) do
#     case find_by_uid_and_auth_token(uid, token) do
#       %User{} = user -> try_auth_admin(conn, user)
#       _ -> conn |> request_basic_auth() |> halt()
#     end
#   end

#   defp try_auth_admin(conn, %User{} = user) do
#     case authenticate_administrator(user) do
#       %User{} = _administrator ->
#         aussie_time = DateTime.to_string(DateTime.shift(DateTime.utc_now(), [hour: +10]))
#         Logger.info("#{user.name} (#{user.permissions}) logged into the site at #{aussie_time} from #{get_remote_ip(conn)}")
#         conn
#       _ -> conn |> request_basic_auth() |> halt()
#     end
#   end

#   def get_remote_ip(conn) do
#     forwarded_for =
#       conn
#       |> Plug.Conn.get_req_header("x-forwarded-for")
#       |> List.first()

#     if forwarded_for do
#       forwarded_for
#       |> String.split(",")
#       |> Enum.map(&String.trim/1)
#       |> List.first()
#     else
#       conn.remote_ip
#       |> :inet_parse.ntoa()
#       |> to_string()
#     end
#   end
# end
