defmodule VsGlobalChatWeb.Components.Login do

  use Surface.LiveComponent
  use Surface.Components.Context
  # import Phoenix.Component, only: [assign: 2, assign: 3, assign_new: 3]
  # import VsGlobalChat.Helpers.Session
  # import Phoenix.Controller
  # import Phoenix.LiveView.Controller

  data login_form, :map, default: %{username: "", password: ""}

  def render(assigns) do
    ~F"""
    <div>
      <SurfaceBulma.Form for={%{}} as={:login_form} opts={autocomplete: "off"} submit={"login", target: :live_view}>
      <Surface.Components.Form.Field name="username">
        <Surface.Components.Form.Label>Username</Surface.Components.Form.Label>
        <div class="control">
          <SurfaceBulma.Form.TextInput value={@login_form["username"]}/>
        </div>
      </Surface.Components.Form.Field>
      <Surface.Components.Form.Field name="password" class="field">
        <Surface.Components.Form.Label>Password</Surface.Components.Form.Label>
        <div class="control">
          <SurfaceBulma.Form.PasswordInput value={@login_form["password"]}/>
        </div>
      </Surface.Components.Form.Field>
      <Surface.Components.Form.Submit class="button is-primary" label="Login"/>
      </SurfaceBulma.Form>
    </div>
    """
  end

  # def mount(_params, _session, socket) do
  #   {:ok, socket}
  # end

end
