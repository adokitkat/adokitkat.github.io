include karax / prelude
import jsutils, dom, jsffi

proc createDom(): VNode =
  result = buildHtml(tdiv):
    text(class="hello-world"):
      "Hello world"

setRenderer createDom
addStylesheet "cv.css"