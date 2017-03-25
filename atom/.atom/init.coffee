# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to make opened Markdown files always be soft wrapped:
#
path = require 'path'

# ----------------------------------------------------------------------------
# Commands
# ----------------------------------------------------------------------------
atom.commands.add 'atom-workspace', 'custom:open-todo-list': ->
    todoList = path.join(process.env.HOME, 'Dropbox/Bucket/Todo.taskpaper')
    atom.workspace.open(todoList)

# ----------------------------------------------------------------------------
# split-diff package
# ----------------------------------------------------------------------------
# This closes the sidebar while a split diff is showing
atom.commands.add('atom-workspace', 'split-diff:toggle', () ->
    atom.commands.dispatch(document.querySelector('atom-text-editor'), 'tree-view:toggle')
)
atom.commands.add('atom-workspace', 'split-diff:enable', () ->
    atom.commands.dispatch(document.querySelector('atom-text-editor'), 'tree-view:toggle')
)
atom.commands.add('atom-workspace', 'split-diff:disable', () ->
    atom.commands.dispatch(document.querySelector('atom-text-editor'), 'tree-view:toggle')
)