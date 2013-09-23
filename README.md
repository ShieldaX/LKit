LKit
-----

Lua user interface engine [lʊkɪt]

###Bio

Inspired by both iOS and Android UI library. Uses within cross-platform mobile application builder Corona driven in lua.

###Implement

Merge platform divergence on user interface, so it looks much vivid.
Recognise Gesture most based on touch, multi-touch and so on.
Render engine works like Webkit and Gecko.

###Usage

```
local win = Window {
  linear {
    name = "linear",
    width = "match",
    height = "match",
    direction = "horizontal",
    View {
      name = "rootView",
      width = "match",
      height = "wrap",
      Button = {
        name = "print",
        width =  "wrap",
        height = "wrap",
      }
    },
    ScrollView {
      name = "scroll",
      width = "match",
      height = "match",
    }
  }
}

win.linear.rootView.print.frame -- global access
```