include karax / prelude
import jsutils, dom, jsffi, strutils

type
  ActionType {.pure.} = enum
    NavbarAction, LanguageAction

  Language {.pure.} = enum
    English, Slovak

  ContentType {.pure.} = enum
    About, Skills, Projects

  ContentItem = object
    title, content : array[2, kstring]

var
  ContentTypeKstring = [kstring"About", "Skills", "Projects"]
  shown_content : ContentType = About
  language : Language = English

proc title(typ: ContentType) : kstring =
  result = case typ
    of About:
      kstring"About"
    of Skills:
      kstring"Skills"
    of Projects:
      kstring"Projects"

proc content(typ: ContentType, part: string) : VNode =
  result = buildHtml(tdiv(class="")):
    case typ
    of About:
      case part
      of "title":
        text [kstring"About", "O mne"][ord(language)]
      of "text":
        text [kstring"""abc""",
              """xyz"""][ord(language)]

    of Skills:
      case part
      of "title":
        text [kstring"Skills", "Schopnosti"][ord(language)]
      of "text":
        text [kstring"""dfe""",
              """qwerty"""][ord(language)]

    of Projects:
      case part
      of "title":
        text [kstring"Projects", "Projekty"][ord(language)]
      of "text":
        text [kstring"""123""",
              """666"""][ord(language)]

proc action(typ: ActionType, entry: kstring): proc() =
  result = proc() = 
    case typ

    of LanguageAction:
      echo "clicked language button"
      if language == English:
        language = Slovak
      elif language == Slovak:
        language = English
    
    of NavbarAction:
      echo "clicked \"", entry, "\" menu button"
      for i, n in ContentTypeKstring:
        if entry == n:
          shown_content = ContentType(i)

proc buildNavbar(): VNode =
  result = buildHtml(nav(class="navbar is-primary")):
    
    tdiv(class="navbar-list center"):
      
      for n in ContentType:
        a(class="navbar-item", onclick=action(NavbarAction, title(n))):
          content(n, "title")
        span():
          text "/"

      a(class="navbar-item", onclick=action(LanguageAction, "")):
          if language == Slovak:
            text "EN"
          else:
            text "SK"

proc buildContent(): VNode =
  result = buildHtml(tdiv):
    tdiv(class="content center"):
      content(shown_content, "text")

proc createDom(): VNode =
  result = buildHtml(tdiv):
    buildNavbar()
    buildContent()

setRenderer createDom