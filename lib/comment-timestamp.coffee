CommentTimestampView = require './comment-timestamp-view'
{CompositeDisposable} = require 'atom'

module.exports = CommentTimestamp =
  config:
    _commentPrefix:
      title: 'Comment prefix'
      type: 'string'
      default: 'edited by <name>'
      description: "Set a prefix to the comment. Timestamp will be appended to the end of this string."

  commentTimestampView: null
  # modalPanel: null
  subscriptions: null

  activate: (state) ->
    @commentTimestampView = new CommentTimestampView(state.commentTimestampViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @commentTimestampView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    # @subscriptions.add atom.commands.add 'atom-workspace', 'comment-timestamp:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-timestamp:comment': => @comment()

  deactivate: ->
    # @modalPanel.destroy()
    @subscriptions.dispose()
    @commentTimestampView.destroy()

  serialize: ->
    commentTimestampViewState: @commentTimestampView.serialize()

  # toggle: ->
  #   console.log 'CommentTimestamp was toggled!'
  #
  #   if @modalPanel.isVisible()
  #     @modalPanel.hide()
  #   else
  #     @modalPanel.show()

  comment: ->
    editor = atom.workspace.getActivePaneItem()
    editor.insertText('\t//\t' + atom.config.get('comment-timestamp._commentPrefix') + ': ' + new Date().toLocaleString())
