React       = require 'react-atom-fork'
{div, span} = require 'reactionary-atom-fork'

module.exports =
TipsComponent = React.createClass
  displayName: 'TipsComponent'
  render: ->
    div {className: 'tips'},
      "Select a process on the left to get started"
