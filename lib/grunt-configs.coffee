TypeSelectorView = require "./type-selector-view"


module.exports =
  typesList: ['json', 'js', 'cson', 'coffee', 'yaml']

  activate: (state) ->
    atom.workspaceView.command "grunt-configs:selectType", => @selectType()
    atom.workspaceView.command "grunt-configs:generate", => @generate()
    @typeSelectorView = new TypeSelectorView @generate.bind(@), @typesList

  deactivate: ->

  serialize: ->

  generate: (type) ->
    console.log "GENERATE " + type

  selectType: ->
    console.log "YEAH!"
    @toggleTypeSelector()

  toggleTypeSelector: ->
    return @typeSelectorView.attach() unless @typeSelectorView.isOnDom()
    return @typeSelectorView.cancel()
