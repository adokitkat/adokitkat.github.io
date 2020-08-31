{.experimental: "codeReordering".}

include karax / prelude
import dom, jsffi, strutils

const
  ContentTypeKstring* = [kstring"About", "Skills", "Projects"]
  Themes* = [kstring"theme theme-light", "theme theme-dark"]

  about_title* = [kstring"About me", "O mne"]
  skills_title* = [kstring"Skills", "Schopnosti"]
  projects_title* = [kstring"Projects", "Projekty"]

  about_text* = [kstring"""Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris mollis vulputate diam vitae consectetur. Maecenas eleifend massa sed maximus placerat. Sed aliquet tincidunt quam efficitur malesuada. Praesent tristique porttitor eros non auctor. Vivamus vitae sapien sapien. Donec lobortis, purus aliquet blandit volutpat, orci tortor dignissim quam, et vehicula neque magna aliquam ligula. Nullam vel ultricies augue. Nam laoreet pellentesque turpis, sit amet blandit ligula pretium ac. Donec dictum magna id commodo maximus. Donec elementum lacinia tortor. Integer tristique, dui viverra sodales gravida, erat mi scelerisque libero, ut mollis ipsum dui et orci. Ut id arcu dapibus, pellentesque dolor at, placerat odio. Sed suscipit auctor justo. Integer dui ipsum, elementum a fermentum eu, bibendum id tellus. Nam eleifend lectus lectus, id ullamcorper velit eleifend ut. Quisque eros nulla, pharetra quis aliquam nec, sollicitudin id arcu.

Integer imperdiet aliquam sem eget vestibulum. Ut iaculis porta congue. Integer at massa sagittis, convallis dui vel, mollis mauris. Ut tincidunt risus at tristique convallis. Aenean quis dictum urna. Aliquam in turpis sit amet arcu fermentum ultrices. Integer faucibus accumsan arcu, in iaculis dui lobortis ut. Nam elementum arcu quis ipsum cursus, sit amet bibendum arcu bibendum. Ut quam lacus, consectetur aliquet massa quis, condimentum malesuada eros. Cras sed aliquet nisl, ac tincidunt ipsum. Vivamus convallis ipsum quis porta mollis. Suspendisse potenti. Praesent sodales malesuada turpis. Suspendisse potenti.

Quisque imperdiet nibh mauris, ut malesuada libero commodo eget. Fusce vitae gravida dolor. Morbi mi dolor, pharetra eget nisl in, placerat imperdiet justo. In hac habitasse platea dictumst. Integer tincidunt magna mi, a molestie elit aliquet sed. Integer nec diam sed massa ornare sollicitudin. Curabitur vel tempor diam. Nunc tempus consectetur erat id aliquam.

Suspendisse molestie purus quis velit tempus, vitae dignissim velit vehicula. Vivamus at vehicula est. Phasellus nunc neque, gravida sed nisi sit amet, pharetra viverra nunc. Pellentesque vel euismod lorem, commodo vestibulum leo. Vivamus aliquam dolor dui, vel ultrices mi ornare non. Nunc vehicula pulvinar metus, ac ornare leo. Pellentesque non pharetra enim.""",
                        """xyz"""]

  skills_text* = [kstring"""dfe""",
                         """qwerty"""]

  projects_text* = [kstring"""123""",
                           """666"""]

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
  result = buildHtml(nav(class=applyTheme(kstring"navbar"))):
    tdiv(class="navbar-list center"):
      var navbar_item : kstring
      for n in ContentType:
        if ord(n) == 0:
          navbar_item = "navbar-item navbar-item-left"
        else:
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
  result = buildHtml(tdiv(class="content-body")):
    content(shown_content, "text")

proc buildFooter(): VNode =
  result = buildHtml(footer(class=applyTheme(kstring"footer"))):
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