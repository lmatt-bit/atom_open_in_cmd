exec = require('child_process').exec
process = require('process')
path = require('path')
fs = require('fs')

escape_command_characters = (input_string) ->
    string_index = 0
    delimiter = "EMPTY"
    character = "EMPTY"

    while(string_index <= input_string.length)
        if input_string.charAt(string_index) == "&"
            delimiter = "^"
            character = "&"
        else if input_string.charAt(string_index) == "^"
            delimiter = "^"
            character = "^"

        if (delimiter != "EMPTY") && (character != "EMPTY")
            pre_char =  input_string.substr 0, string_index
            post_char = input_string.slice(string_index + 1)
            input_string = pre_char + delimiter + character + post_char

            delimiter = "EMPTY"
            character = "EMPTY"
            string_index += 1

        string_index += 1

    return input_string

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', 'open-in-cmd:open', => @open_in_cmd()
    atom.commands.add '.tree-view .selected', 'open-in-cmd:open_path' : (event) => @open_in_cmd(event.currentTarget)

  open_in_cmd: (target) ->
    if target?
      select_file = target.getPath?() ? target.item?.getPath() ? target
    else
      select_file = atom.workspace.getActivePaneItem()?.buffer?.file?.getPath()
      select_file ?= atom.project.getPaths()?[0]

    if select_file? and fs.lstatSync(select_file).isFile()
      dir_path = path.dirname(select_file)
    else
      dir_path = select_file

    dir_path = escape_command_characters(dir_path)

    exec "start cmd /k \"cd /d \"#{dir_path}\"\""
