include karax / prelude
import jsutils, dom, jsffi

type
  ActionType {.pure.} = enum
    NavbarAction, ButtonAction, LanguageAction

  Language {.pure.} = enum
    English, Slovak

  ContentItem = object
    title, content : array[2, kstring]

const
  languages = [kstring"EN", "SK"]

  about_title = [kstring"About", "O mne"]
  about_text = [kstring"""
About me in English...
""",
"""
O mne po slovensky...
"""]

  skills_title = [kstring"", ""]
  skills_text = [kstring"", ""]

  projects_title = [kstring"", ""]
  projects_text = [kstring"", ""]

  navbar_list : seq[ContentItem] = @[ContentItem(title: about_title, content: about_text),
                                     ContentItem(title: skills_title, content: skills_text),
                                     ContentItem(title: projects_title, content: projects_text)]
var
  shown_content = 0
  language : Language = Slovak

proc `[]`(obj: JsObject; field: Language): JsObject =
  result = obj[ord(field)]

proc `[]`[T](arr: openArray[T]; field: Language): T =
  result = arr[ord(field)]

proc `[]`[T](arr: openArray[var T]; field: Language): var T =
  result = arr[ord(field)]

proc action(typ: ActionType, entry: kstring): proc() =
  result = proc() = 
    case typ
    of NavbarAction:
      echo "clicked \"", entry, "\" menu button"
      for i, item in navbar_list:
        if entry == item.title[language]:
          shown_content = i

    of LanguageAction:
      echo "clicked language button"
      if language == English:
        language = Slovak
      elif language == Slovak:
        language = English

    of ButtonAction:
      echo "clicked \"", entry, "\" normal button"

proc buildNavbar(): VNode =
  result = buildHtml(nav(class="navbar is-primary")):
    tdiv(class="navbar-list center"):
      for i, m in navbar_list:
        span():
          text "/"
        a(class="navbar-item", onclick=action(NavbarAction, m.title[language])):
          text m.title[language]

      a(class="navbar-item", onclick=action(LanguageAction, "")):
          text languages[language]

proc buildContent(): VNode =
  result = buildHtml(tdiv):
    tdiv(class="content center"):
      text navbar_list[shown_content].content[language]

proc createDom(): VNode =
  result = buildHtml(tdiv):
    buildNavbar()
    buildContent()

setRenderer createDom