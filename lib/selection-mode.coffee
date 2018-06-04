{CompositeDisposable, Point} = require 'atom'

# these are the four basic underlying cursor-movement methods.
# see https://github.com/atom/atom/blob/master/src/cursor.coffee
movementMethods = ["moveUp", "moveDown", "moveLeft", "moveRight"]

module.exports = SelectionMode =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
    'selection-mode:toggle': => @toggle()
    'selection-mode:toggle-without-deselecting': => @toggle({deselect: false})
    'selection-mode:cancel': => @toggleOff()
    'selection-mode:off': => @toggleOff(null, {deselect: false})

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  toggle: ({deselect} = {deselect: true}) ->
    textEditor = atom.workspace.getActiveTextEditor()
    view = atom.views.getView(textEditor)

    # toggle whether the mark is on or not
    view.classList.toggle("selection-mode")

    # if we're toggling on
    if view.classList.contains("selection-mode")
      #console.log 'TransientMarkMode was toggled on!'
      @toggleOn(textEditor)
    else
      #console.log 'TransientMarkMode was toggled off!'
      # toggling off
      @toggleOff(textEditor, {deselect})

    # initialize the cursor movement callback just once.
    unless textEditor.transientMarkModeInitialized

      # when the cursor position is changed...
      textEditor.onDidChangeCursorPosition (event) =>

        # and mark is toggled on...
        if view.classList.contains("selection-mode")
          if event.textChanged
            # we did something with the selection, so turn it off
            @toggleOff(textEditor, {deselect})
            return

          mark = textEditor.transientMarker.getHeadPosition()

          # do some math-y stuff to expand/contract the selection
          if event.oldBufferPosition.isLessThan(event.newBufferPosition)
            textEditor.expandSelectionsForward (selection) ->
              selection.marker.setTailBufferPosition(mark)
              selection.selectRight() until selection.getBufferRange().containsPoint(event.newBufferPosition)
          else
            textEditor.expandSelectionsBackward (selection) ->
              selection.marker.setTailBufferPosition(mark)
              selection.selectLeft() until selection.getBufferRange().containsPoint(event.newBufferPosition)

      textEditor.onDidChange () =>
        @toggleOff(textEditor)

    textEditor.transientMarkModeInitialized = true

  toggleOn: (textEditor = atom.workspace.getActiveTextEditor()) ->
    # mark the current position
    textEditor.transientMarker = textEditor.getBuffer().markPosition(textEditor.getCursorBufferPosition())
    @fixCursors(textEditor) # we can't have the moveToEndOfSelection default option set!

  toggleOff: (textEditor = atom.workspace.getActiveTextEditor(), {deselect} = {deselect: true}) ->
    atom.views.getView(textEditor).classList.remove("selection-mode")
    textEditor.transientMarker = null
    @clearSelections(textEditor) if deselect
    @unfixCursors(textEditor) # but we should be polite and put it back how we found it.

  clearSelections: (textEditor) ->
    for selection in textEditor.getSelections()
      unless selection.isEmpty()
        selection.clear()

  fixCursors: (textEditor) ->
    for cursor in textEditor.getCursors()
      for movementMethod in movementMethods
        @fixMovementMethod(cursor, movementMethod)

  unfixCursors: (textEditor) ->
    for cursor in textEditor.getCursors()
      for movementMethod in movementMethods
        @unfixMovementMethod(cursor, movementMethod)

  fixMovementMethod: (cursor, method) ->
    cursor[@stash_name(method)] = cursor[method]
    cursor[method] = (amountArg) =>
      # console.log("calling #{method} and #{@stash_name(method)}!")
      # all this, just so I can force the moveToEndOfSelection to be false
      # at least I can say that they were nice enough to have coherent
      # method signatures for all 4 movement methods
      cursor[@stash_name(method)].call(cursor, amountArg, {moveToEndOfSelection: false})

  unfixMovementMethod: (cursor, method) ->
    # sanity check, is there anything to unfix?
    if cursor[@stash_name(method)]?
      cursor[method] = cursor[@stash_name(method)]
      delete cursor[@stash_name(method)]

  stash_name: (name) ->
    "__original__#{name}"
