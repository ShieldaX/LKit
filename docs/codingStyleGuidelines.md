Coding Style Guidelines
======

Common
------

- Use 2 spaces instead of tab
- Never use global variables and global functions in library files
- File name conventions: Capitalize for 'class like' modules which usually should used with `new()`, otherwise are `pure modules` that more like namespaces (example the `util` and `debug` module)

Table
------

Avoid using hyphened string as table's key:
X "z-index"(confuse with minus operation)
V "zIndex"(recommended) or "z_index"(okey but not good)

Table Define:

Generally like this,

```
self.font = {
  section = {
    header = {size = 24, font = native.systemFont},
    Footer = {size = 24, font = native.systemFont}
  },
  row = {size = 20, font = native.systemFontBold}
}

local dataSource = {
  header = {labelText = "Country List"},
  {
    titleHeader = "Asia",
    {text = "China"},
    {text = "Korea"},
    {text = "Japan"},
    {text = "India"},
  },
  {
    titleHeader = "North America",
    {text = "United States"},
    {text = "Canada"},
  },
}
```

- - -

Function
------

Do this,

```
function foo(bar)
  -- do something
end
```
Not like this,

```
function foo ( bar )
    -- do something
end
```
- - -

