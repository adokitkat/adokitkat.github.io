include karax / prelude
import jsutils, dom, jsffi

proc createDom(): VNode =
  result = buildHtml(tdiv):
    tdiv(class="hello-world"):
      text "Hello world"

setRenderer createDom