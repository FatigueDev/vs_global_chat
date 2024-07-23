defmodule VsGlobalChatWeb.FakeLiveTest do
  use VsGlobalChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import VsGlobalChat.FakeThingFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_fake(_) do
    fake = fake_fixture()
    %{fake: fake}
  end

  describe "Index" do
    setup [:create_fake]

    test "lists all fakes", %{conn: conn, fake: fake} do
      {:ok, _index_live, html} = live(conn, ~p"/fakes")

      assert html =~ "Listing Fakes"
      assert html =~ fake.name
    end

    test "saves new fake", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/fakes")

      assert index_live |> element("a", "New Fake") |> render_click() =~
               "New Fake"

      assert_patch(index_live, ~p"/fakes/new")

      assert index_live
             |> form("#fake-form", fake: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fake-form", fake: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fakes")

      html = render(index_live)
      assert html =~ "Fake created successfully"
      assert html =~ "some name"
    end

    test "updates fake in listing", %{conn: conn, fake: fake} do
      {:ok, index_live, _html} = live(conn, ~p"/fakes")

      assert index_live |> element("#fakes-#{fake.id} a", "Edit") |> render_click() =~
               "Edit Fake"

      assert_patch(index_live, ~p"/fakes/#{fake}/edit")

      assert index_live
             |> form("#fake-form", fake: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fake-form", fake: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fakes")

      html = render(index_live)
      assert html =~ "Fake updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes fake in listing", %{conn: conn, fake: fake} do
      {:ok, index_live, _html} = live(conn, ~p"/fakes")

      assert index_live |> element("#fakes-#{fake.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#fakes-#{fake.id}")
    end
  end

  describe "Show" do
    setup [:create_fake]

    test "displays fake", %{conn: conn, fake: fake} do
      {:ok, _show_live, html} = live(conn, ~p"/fakes/#{fake}")

      assert html =~ "Show Fake"
      assert html =~ fake.name
    end

    test "updates fake within modal", %{conn: conn, fake: fake} do
      {:ok, show_live, _html} = live(conn, ~p"/fakes/#{fake}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Fake"

      assert_patch(show_live, ~p"/fakes/#{fake}/show/edit")

      assert show_live
             |> form("#fake-form", fake: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#fake-form", fake: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/fakes/#{fake}")

      html = render(show_live)
      assert html =~ "Fake updated successfully"
      assert html =~ "some updated name"
    end
  end
end
