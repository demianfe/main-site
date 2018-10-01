
include karax / prelude 
import karax / prelude
import  karax / [errors, kdom, kajax, vstyles]

import sugar, json
import sections, placeholder

import components / [documentation, collaborate, contact, menu]

const headers = [(cstring"Content-Type", cstring"application/json")]

var lang = cont["default-lang"].getStr()

var loadedData = cont
var c: JsonNode

proc loadData() =
  echo "loading data"
  ajaxGet("/contents.json",
          headers,
          proc(stat:int, resp:cstring) =
            loadedData = parseJson($resp)
  )
  
proc logoheader*(logo, title: string):Vnode =
    result = buildHtml(tdiv()):
      header(class="masthead"):
        tdiv(class="container"):
          tdiv(class="intro-text"):
            img(class="mobil", src=logo, alt=title)

            
proc MainContainer(c: JsonNode): VNode =
  result = buildHtml(tdiv()):
    menuContent(c["menu"])
    logoheader(c["logo"].getStr(), c["page_title"].getStr())
    tdiv(class="container"):
      tdiv(class="col-md")
      tdiv(class="col-md embed-responsive embed-responsive-16by9"):
        iframe( src="https://www.youtube.com/embed/iDWjboeo0uM",
                allowfullscreen="true")
      tdiv(class="col-md")
    parts(c["sections"])
    documentation(c["documentation"])
    collaborate(c)
    contact(c["contacts"])

proc createDOM(data: RouterData): VNode =
  if c.isNil:
    loadData()
  c = loadedData[lang]
  result = buildHtml(tdiv()):
    MainContainer(c)
    script( src="js/agency.js")

setRenderer createDOM
