include karax / prelude
import dom, jsffi, strutils

type
  ActionType {.pure.} = enum
    NavbarAction, LanguageAction, ThemeAction

  Language {.pure.} = enum
    English, Slovak
  
  Theme = enum
    Light, Dark

  ContentType {.pure.} = enum
    About, Skills, Projects

const
  ContentTypeKstring = [kstring"About", "Skills", "Projects"]
  Themes = [kstring"theme theme-light", "theme theme-dark"]
var
  shown_content : ContentType = About
  language : Language = English
  theme : Theme = Light

proc title(typ: ContentType) : kstring =
  result = case typ
    of About:
      kstring"About"
    of Skills:
      kstring"Skills"
    of Projects:
      kstring"Projects"

proc content(typ: ContentType, part: string) : VNode =
  result = buildHtml(tdiv(class="content")):
    case typ
    of About:
      case part
      of "title":
        text [kstring"About", "O mne"][ord(language)]
      of "text":
        #h2:
        #  text "Adam Múdry"
        p:
          text ["""abc""",
              """xyz"""            
              ][ord(language)]
        
    of Skills:
      case part
      of "title":
        text [kstring"Skills", "Schopnosti"][ord(language)]
      of "text":
        p:
          text ["""dfe""",
              """qwerty"""][ord(language)]

    of Projects:
      case part
      of "title":
        text [kstring"Projects", "Projekty"][ord(language)]
      of "text":
        p:
          text ["""123""",
              """666"""][ord(language)]

proc applyTheme(s: kstring) : kstring =
  if s == "theme":
    if theme == Theme.Dark:
      result = Themes[ord(Theme.Dark)]
    elif theme == Theme.Light:
      result = Themes[ord(Theme.Light)]

  elif s == "nim-link":
    if theme == Theme.Dark:
      result = kstring"nim-link nim-link-light"
    elif theme == Theme.Light:
      result = kstring"nim-link nim-link-dark"

proc action(typ: ActionType, entry: kstring): proc() =
  result = proc() = 
    case typ
    of LanguageAction:
      echo "clicked language button"
      if language == English:
        language = Slovak
      elif language == Slovak:
        language = English

    of ThemeAction:
      echo "clicked theme button"
      if theme == Theme.Dark:
        theme = Theme.Light
      elif theme == Theme.Light:
        theme = Theme.Dark
    
    of NavbarAction:
      echo "clicked \"", entry, "\" menu button"
      for i, n in ContentTypeKstring:
        if entry == n:
          shown_content = ContentType(i)

proc buildNavbar(): VNode =
  result = buildHtml(nav(class="navbar")):
    tdiv(class="navbar-list center"):
      var navbar_item : kstring
      for n in ContentType:
        if ord(n) == 0 :
          navbar_item = "navbar-item navbar-item-left"
        else :
          navbar_item = "navbar-item"

        a(class=navbar_item, onclick=action(NavbarAction, title(n))):
          content(n, "title")
        if n < ContentType.high:
          span():
            text "/"
    
      tdiv(class="navbar-break"):
      #[
        span():
            text "~"
      ]#
        a(class="navbar-item", onclick=action(LanguageAction, "")):
            if language == Slovak:
              text "EN"
            else:
              text "SK"
        
        span():
            text "/"
        
        a(class="navbar-item navbar-item-right", onclick=action(ThemeAction, "")):
            if theme == Theme.Light:
              text "Dark"
            else:
              text "Light"

proc buildContent(): VNode =
  result = buildHtml(tdiv(class="content-body center")):
    content(shown_content, "text")

proc buildFooter(): VNode =
  result = buildHtml(footer(class="footer center")):
    text "Powered by "
    a(class=applyTheme(kstring"nim-link"), href="https://nim-lang.org/"):
      text "NIM"
    span():
      text " | "
    text "Adam Múdry 2020"

proc createDom(data: RouterData): VNode =
  if data.hashPart == "#/sk": language = Slovak # doesn't work on Github Pages...
  result = buildHtml(tdiv(class=applyTheme(kstring"theme"))):
    buildNavbar()
    buildContent()
    buildFooter()

setRenderer createDom