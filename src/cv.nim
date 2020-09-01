{.experimental: "codeReordering".}

include karax / prelude
import dom, jsffi, strutils, cookies

proc find(s: cstring, a: cstring): int {.importcpp: "#.indexOf(#)".}
proc contains*(s, sub: cstring): bool {.noSideEffect.} = return find(s, sub) >= 0

const
  ContentTypeKstring* = [kstring"About", "Skills", "Projects"]
  Themes* = [kstring"theme theme-light", "theme theme-dark"]

  about_title* = [kstring"About me", "O mne"]
  skills_title* = [kstring"Skills", "Schopnosti"]
  projects_title* = [kstring"Projects", "Projekty"]

  about_text* = [kstring"Work in progress...",
                        "Na stránke sa pracuje..."]

  skills_text* = [kstring"Work in progress...",
                         "Na stránke sa pracuje..."]

  projects_text* = [kstring"Work in progress...",
                           "Na stránke sa pracuje..."]

type
  ActionType {.pure.} = enum
    NavbarAction, LanguageAction, ThemeAction

  Language {.pure.} = enum
    English, Slovak
  
  Theme = enum
    Light, Dark

  ContentType {.pure.} = enum
    About, Skills, Projects

var
  shown_content : ContentType = Projects
  language : Language = Slovak
  theme : Theme = Light
  on_load : bool = false

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
        text about_title[ord(language)]
      of "text":
        p:
          text about_text[ord(language)]
        
    of Skills:
      case part
      of "title":
        text skills_title[ord(language)]
      of "text":
        p:
          text skills_text[ord(language)]

    of Projects:
      case part
      of "title":
        text projects_title[ord(language)]
      of "text":
        tdiv(class="projects"):
          tdiv(class="project"):
            h3: text ["Apache log viewer & filter", "Nástroj pre zobrazovanie a filtrovanie Apache logov"][ord(language)]
            
            tdiv(class="language"):
              p(class="left"): text ["Language:", "Jazyk:"][ord(language)]
              p(class="right"): text "Shell script"
            
            tdiv(class="os"):
              p(class="left"): text "OS:"
              p(class="right"): text "Linux, BSD, MacOS"
            
            tdiv(class="links"):
              a(class="button github", href="https://github.com/adokitkat/vut-fit-ios-1"): text "</> Github"

          tdiv(class="project"):
            h3: text ["Public transport line simulator", "Simulátor liniek hromadnej dopravy"][ord(language)]
            
            p(class="left"): text ["Uses A* path-finding algorithm", "Používa A* algoritmus na nájdenie cesty"][ord(language)]

            tdiv(class="language"):
              p(class="left"): text ["Language:", "Jazyk:"][ord(language)]
              p(class="right"): text "C++, Qt5"
            
            tdiv(class="os"):
              p(class="left"): text "OS:"
              p(class="right"): text "Windows, Linux"
            
            tdiv(class="links"):
              a(class="button github", href="https://github.com/adokitkat/vut-fit-icp"): text "</> Github"
              a(class="button", href="https://github.com/adokitkat/vut-fit-icp/releases"): text ["<~> Try it", "<~> Vyskúšaj"][ord(language)]

          tdiv(class="project"):
            h3: text ["Packet sniffer (IPv4)", "Sniffer packetov (IPv4)"][ord(language)]
            
            tdiv(class="language"):
              p(class="left"): text ["Language:", "Jazyk:"][ord(language)]
              p(class="right"): text "C++"
            
            tdiv(class="os"):
              p(class="left"): text "OS:"
              p(class="right"): text "Linux"
            
            tdiv(class="links"):
              a(class="button github", href="https://github.com/adokitkat/vut-fit-ipk-2"): text "</> Github"

          tdiv(class="project"):
            h3: text ["This portfolio page", "Táto portfólio stránka"][ord(language)]
            
            p(class="left"): text ["Single-page web app experiment with automatized building via Github Actions", "Single-page web app experiment s automatickým stavaním pomocou Github Actions"][ord(language)]

            tdiv(class="language"):
              p(class="left"): text ["Language:", "Jazyk:"][ord(language)]
              p(class="right"): text ["Nim (compiled to JS), Sass", "Nim (skompilovaný na JS), Sass"][ord(language)]
            
            tdiv(class="links"):
              a(class="button github", href="https://github.com/adokitkat/adokitkat.github.io"): text "</> Github"

proc parseCookieTheme(start : var bool) =
  if start == false:
    start = true
    if document.cookie.contains("Dark"):
      theme = Theme.Dark

proc applyTheme(s: kstring) : kstring =
  if s == "theme":
    if theme == Theme.Dark:
      result = Themes[ord(Theme.Dark)]
    elif theme == Theme.Light:
      result = Themes[ord(Theme.Light)]

  elif s == "nim-link":
    if theme == Theme.Dark:
      result = kstring"nim-link nim-link-dark"
    elif theme == Theme.Light:
      result = kstring"nim-link nim-link-light"

  elif s == "navbar":
    if theme == Theme.Dark:
      result = kstring"navbar navbar-dark"
    elif theme == Theme.Light:
      result = kstring"navbar navbar-light"

  elif s == "footer":
    if theme == Theme.Dark:
      result = kstring"footer center footer-dark"
    elif theme == Theme.Light:
      result = kstring"footer center footer-light"

proc action(typ: ActionType, entry: kstring): proc() =
  result = proc() = 
    case typ
    of LanguageAction:
      #echo "clicked language button"
      if language == English:
        language = Slovak
      elif language == Slovak:
        language = English

    of ThemeAction:
      #echo "clicked theme button"
      if theme == Theme.Dark:
        theme = Theme.Light
      elif theme == Theme.Light:
        theme = Theme.Dark
    
      document.cookie = setCookie(key="Theme", value=`$`theme, domain="adokitkat.github.io", path="/")

    of NavbarAction:
      #echo "clicked \"", entry, "\" menu button"
      for i, n in ContentTypeKstring:
        if entry == n:
          shown_content = ContentType(i)

proc buildNavbar(): VNode =
  result = buildHtml(nav(class=applyTheme(kstring"navbar"))):
    tdiv(class="navbar-list center"):
      var navbar_item : kstring
      for n in ContentType:
        if n == ContentType.low:
          navbar_item = "navbar-item navbar-item-left"
        elif n == ContentType.high:
          navbar_item = "navbar-item navbar-item-right"
        else:
          navbar_item = "navbar-item"

        a(class=navbar_item, onclick=action(NavbarAction, title(n))):
          content(n, "title")
        if n < ContentType.high:
          span():
            text "/"
    
      tdiv(class="navbar-break"):
        a(class="navbar-item", onclick=action(LanguageAction, "")):
            if language == Slovak:
              text "EN"
            else:
              text "SK"
        
        span():
            text "/"
        
        a(class="navbar-item", onclick=action(ThemeAction, "")):
            if theme == Theme.Light:
              text "Dark"
            else:
              text "Light"

proc buildContent(): VNode =
  result = buildHtml(tdiv(class="content-body")):
    content(shown_content, "text")

proc buildFooter(): VNode =
  result = buildHtml(footer(class=applyTheme(kstring"footer"))):
    #[
    text "Powered by "
    a(class=applyTheme(kstring"nim-link"), href="https://nim-lang.org/"):
      text "NIM"
    span():
      text " | "
    ]#
    text "Adam Múdry 2020"

proc createDom(data: RouterData): VNode =
  parseCookieTheme(on_load)
  if data.hashPart == "#/sk": language = Slovak # doesn't work on Github Pages...
  result = buildHtml(tdiv(class=applyTheme(kstring"theme"))):
    buildNavbar()
    buildContent()
    buildFooter()

setRenderer createDom
