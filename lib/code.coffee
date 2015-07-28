exec = require('child_process').exec
process = require('process')
path = require('path')
fs = require('fs')

module.exports =
  activate: ->
    atom.commands.add '.tree-view', 'open-in-cmd:open', => @open_in_cmd()

  open_in_cmd: ->
    
    select_file = atom.workspace.getActivePaneItem()?.buffer?.file?.getPath()

    if select_file? and fs.lstatSync(select_file).isFile()
      dir_path = path.dirname(select_file)
    else
      dir_path = select_file

    exec "start cmd /Dir \"#{dir_path}\""
