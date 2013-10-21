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

