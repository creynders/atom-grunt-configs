TypeSelectorView = require "./type-selector-view"
{BufferedProcess} = require 'atom'
{MessagePanelView, PlainMessageView} = require 'atom-message-panel'

module.exports =
  typesList: ['json', 'js', 'cson', 'coffee', 'yaml']

  activate: (state) ->
    atom.config.setDefaults("grunt-configs", targetDirectory: 'config');
    atom.workspaceView.command "grunt-configs:generate", => @selectType()
    @typeSelectorView = new TypeSelectorView @generate.bind(@), @typesList
    @createMenu()

  deactivate: ->

  serialize: ->

  createMenu: ->
    menu =
      label: 'Packages'
      submenu: [
        label: 'Generate Grunt configs'
        submenu: []
      ]

    self=@
    @typesList.forEach( (type)->
      self['generate_'+ type] = ->
        self.generate(type)
      atom.workspaceView.command "grunt-configs:generate_" + type, => self['generate_'+ type]()
      menu.submenu[0].submenu.push({label: type, command: 'grunt-configs:generate_'+type})
    )
    atom.menu.add [menu]

  createMessagePane: ->
    @messages = new MessagePanelView title: 'Grunt configs' unless @messages
    @messages.attach() unless @messages.isOnDom()

  showMessage: (message, type)->
    opts = {
      raw:true
    }
    switch type
      when 'output'
        opts.message = '<code>'+message.trim().replace( /[\r\n]+/g, '<br />')+'</code>';
        opts.className = 'grunt-output';
      when undefined
        opts.message = message;
      else
        opts.message = message;
        opts.className = 'text-' + type;
    @messages.add new PlainMessageView opts

  generate: (type) ->
    @createMessagePane()
    stdout = (out) ->
      @showMessage out, 'output'
    stderr = (out) ->
      @showMessage out, 'output'
    exit = (code) ->
      atom.beep()
      if( code != 0)
        @showMessage "Could not generate Grunt config files!", 'error'
      else
        @showMessage "Finished generating Grunt config files!", 'success'
        @showMessage 'See instructions on <a href="https://github.com/creynders/load-grunt-configs">load-grunt-configs</a> on how to use them in your Gruntfile.js', 'info'

    targetDir = atom.config.get 'grunt-configs.targetDirectory'
    @showMessage "Generating Grunt configs as '" + type + "' files in '" + targetDir + "' directory.", 'info'
    try
      @process = new BufferedProcess
        command: __dirname + '/../node_modules/.bin/generate_configs'
        args: [
          '--no-color=true',
          '--no-prompt=true',
          '--'+type+'=true',
          '--target='+ targetDir
        ]
        options: {cwd: atom.project.getPath()}
        stdout: stdout.bind @
        exit: exit.bind @
    catch err
      @showMessage err, 'error'

  selectType: ->
    @toggleTypeSelector()

  toggleTypeSelector: ->
    return @typeSelectorView.attach() unless @typeSelectorView.isOnDom()
    return @typeSelectorView.cancel()
