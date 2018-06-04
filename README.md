# selection-mode package

When selection-mode is on, ALL cursor movement modifies the selection. [View on atom.io](https://atom.io/packages/selection-mode).

## Description

When you toggle `selection-mode` on, we set a mark where the cursor is. Then, any movement of the cursor will expand/contract the selection from that original mark.

When selection-mode is on, doing anything that changes the text buffer (typing, deleting, etc.) will also implicitly toggle selection-mode off.

## Advantages

This package is better than other packages that offer similar functionality, because:
* No need to update any keybindings, ever. If you customize your cursor movement keybindings, add custom cursor movement commands via other packages, etc., it still just works like you expect. We jack in to the cursor movement methods at the lowest level, so literally ANY cursor movement will modify the selection.
* no default keybindings, so you can choose your own that works for you.


## Example keybinding

```coffee
# these work best in pairs. either this pair:
'atom-workspace atom-text-editor.editor':
  'ctrl-space': 'selection-mode:toggle'

'atom-workspace atom-text-editor.editor.selection-mode':
  # this one toggles off without deselecting, which works
  # well with the above, which deselects when toggling off
  'ctrl-g': 'selection-mode:off'


# ...or this pair
'atom-workspace atom-text-editor.editor':
  # this toggles but won't deselect when toggling back off
  'ctrl-space': 'selection-mode:toggle-without-deselecting'

'atom-workspace atom-text-editor.editor.selection-mode':
  # this is your dedicated toggle-off-and-deselect
  'ctrl-g': 'selection-mode:cancel'
```

## Issues

* Please file github issues for any bugs.
* If there are configuration options (for example, optional rules for automatic toggle-off) or other feature requests, github issues (or pull requests!) are welcome for that too.


## Inspiration

This package was inspired by my dependence on emacs' `transient-mark-mode`


## Building and Publishing

Reminder: To publish a new version, do NOT manually change anything in any files. Just run `apm publish <newversion>` and it will do everything.
