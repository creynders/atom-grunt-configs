
{SelectListView, $$} = require 'atom'

module.exports = class TypeSelectorView extends SelectListView
    callback: ->
    items: []

    initialize:(callback, types = {}) ->
      super

      @callback = callback
      @setItems if Array.isArray types then types else []

      @addClass 'overlay from-top'
      @setMaxItems 5

      _this = @
      this.filterEditorView.on 'keydown', (evt) ->
          if evt.which == 13
              selected = _this.getSelectedItem()
              text = _this.filterEditorView.getEditor().getBuffer().getText()

              _this.confirmed if selected then selected else text

    # adds a single item to top of the list
    # or moves the item to the top if it was already there
    addItem:(item) ->
        @items = [item].concat @items.filter (value) ->
            item != value

    # helper function: addItem for multiple items
    addItems:(items) ->
        @addItem item for item in items

    # called when an Item is selected
    confirmed:(item) ->
        @addItem item
        @cancel()
        @callback item

    # called whenever the list is attached to the dom
    # makes sure to fill list up and set focus on editor
    attach: ->
        @populateList()
        atom.workspaceView.append @
        @focusFilterEditor()

    # returns JSON object representing state
    serialize: ->
        return items: @items.slice 0, 4

    # uses jquery(?) to return an object
    viewForItem:(task) ->
        $$ ->
            @li task

    # my empty message
    getEmptyMessage: ->
        "Press Enter to run the task."
