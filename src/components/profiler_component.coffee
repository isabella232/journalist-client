React       = require 'react-atom-fork'
Reactionary = require 'reactionary-atom-fork'

{div, span}                       = Reactionary
{table, thead, tbody, tr, td, th} = Reactionary

module.exports =
ProfilerComponent = React.createClass
  displayName: 'ProfilerComponent'
  render: ->
    div {className: 'profiler'},
      AllocationsComponent { allocations: @props.allocations }

AllocationsComponent = React.createClass
  displayName: 'AllocationsComponent'
  render: ->
    nodes = []

    for type of @props.allocations
      count = @props.allocations[type]
      nodes.push AllocationComponent {
        type:  type
        count: count
        key:   "allocations:#{ type }"
      }

    div {className: 'allocations'},
      table {},
        thead {},
          tr {},
            th "Type"
            th "Allocations"
        tbody {},
          nodes

AllocationComponent = React.createClass
  displayName: 'AllocationComponent'
  render: ->
    tr {},
      td @props.type
      td @props.count
