include karax / prelude
import jsutils, dom, jsffi

type
  NavbarItem = object
    menu_title, content : kstring

const
  navbar_list : seq[NavbarItem] = @[NavbarItem(menu_title: "About", content: ""),
                                    NavbarItem(menu_title: "Skills", content: ""),
                                    NavbarItem(menu_title: "Projects", content: "")]
var mode = 0

proc buildMenu(): VNode =
  result = buildHtml(nav(class="navbar is-primary")):
    tdiv(class="navbar-list center"):
      for i, m in navbar_list:
        if i != 0:
          span():
            text "/"
        a(class="navbar-item"):
          text m.menu_title

proc createDom(): VNode =
  result = buildHtml(tdiv):
    buildMenu()
    tdiv(class="hello-world"):
      text "Hello world"

setRenderer createDom