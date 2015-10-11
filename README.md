# selection-mode package

When selection-mode is on, ALL cursor movement modifies the selection

## Description

When you toggle `selection-mode` on, we set a mark where the cursor is. Then, any movement of the cursor will expand/contract the selection from that original mark.

When selection-mode is on, doing anything that changes the text buffer (typing, deleting, etc.) will also implicitly toggle selection-mode off.

## Advantages

This package is better than other packages that offer similar functionality, because:
* No need to update any keybindings, ever. If you customize your cursor movement keybindings, add custom cursor movement commands via other packages, etc., it still just works like you expect. We jack in to the cursor movement methods at the lowest level, so literally ANY cursor movement will modify the selection.
* no default keybindings, so you can choose your own that works for you.


## Example keybinding

```coffee
# you really only need this one
'atom-workspace atom-text-editor.editor':
  'ctrl-space': 'selection-mode:toggle'

# I like to have a dedicated "off" keybinding too
'atom-workspace atom-text-editor.editor.selection-mode':
  'ctrl-g': 'selection-mode:cancel'
```

## Issues

* Please file github issues for any bugs.
* If there are configuration options (for example, optional rules for automatic toggle-off) or other feature requests, github issues (or pull requests!) are welcome for that too.


## Inspiration

This package was inspired by my dependence on emacs' `transient-mark-mode`
