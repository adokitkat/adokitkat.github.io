include karax / prelude
import jsutils, dom, jsffi

type
  ActionType {.pure.} = enum
    MenuAction, ButtonAction

  ContentItem = object
    menu_title, content : kstring

const
  text_about : kstring = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in pulvinar dolor. Fusce non porta est. Donec blandit feugiat leo, ut porta urna. Fusce est augue, tempor ac risus eu, consectetur aliquam nisl. Nulla consectetur, purus consectetur tempor ultricies, leo lectus commodo ante, at varius erat ex ac tortor. Aenean scelerisque nisl in blandit volutpat. Donec nec vehicula nisi, et feugiat quam. Mauris nec nisi sit amet purus interdum fermentum. Aenean rutrum condimentum dapibus. Morbi vulputate ut lorem quis iaculis. Donec pharetra velit ac convallis ornare.

Duis scelerisque, enim vitae sollicitudin semper, ante odio tempus mauris, non porttitor ante justo et metus. Praesent lacinia consectetur consequat. Integer iaculis, urna quis ullamcorper maximus, urna tellus dignissim elit, eget luctus diam orci in lectus. Praesent tristique vehicula justo vitae pulvinar. Phasellus tincidunt, orci ut suscipit tincidunt, augue massa laoreet metus, ut mollis purus purus nec enim. Cras vitae pharetra lacus. Integer volutpat, nisi quis tempor ornare, tellus sapien ultricies odio, in condimentum purus risus in ante. Aliquam erat volutpat. Aliquam sed nibh feugiat, tempus elit at, pulvinar arcu. Aliquam porta mi sodales, rhoncus eros vitae, venenatis lectus. Ut interdum nisi quis ante gravida lacinia. Nunc pretium, odio non molestie ultrices, libero mi gravida orci, quis lacinia leo elit ac arcu. Integer pretium elementum odio sed commodo. Quisque eget ligula a lectus pharetra sagittis id non elit. Nullam vitae consequat libero.
"""
  text_skills : kstring
  text_projects : kstring

  navbar_list : seq[ContentItem] = @[ContentItem(menu_title: "About", content: text_about),
                                     ContentItem(menu_title: "Skills", content: text_skills),
                                     ContentItem(menu_title: "Projects", content: text_projects)]
var mode = 0

proc action(typ: ActionType, entry: kstring): proc() =
  result = proc() = 
    case typ
    of MenuAction:
      echo "clicked \"", entry, "\" menu button"
      for i, item in content_list:
        if entry == item.menu_title:
          mode = i

    of ButtonAction:
      echo "clicked \"", entry, "\" normal button"

proc buildMenu(): VNode =
  result = buildHtml(nav(class="navbar is-primary")):
    tdiv(class="navbar-list center"):
      for i, m in navbar_list:
        if i != 0:
          span():
            text "/"
        a(class="navbar-item"):
          text m.menu_title

proc buildContent(): VNode =
  result = buildHtml(tdiv):
    tdiv(class="content center"):
      text navbar_list[mode].content

proc createDom(): VNode =
  result = buildHtml(tdiv):
    buildMenu()
    buildContent()
    tdiv(class="center"):
      text "Hello world"

setRenderer createDom