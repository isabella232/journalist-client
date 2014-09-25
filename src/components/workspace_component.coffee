React       = require 'react-atom-fork'
{div, span} = require 'reactionary-atom-fork'

SidebarComponent  = require 'src/components/sidebar_component'
ProfilerComponent = require 'src/components/profiler_component'
TipsComponent     = require 'src/components/tips_component'

module.exports =
WorkspaceComponent = React.createClass
  displayName: 'WorkspaceComponent'

  getInitialState: ->
    { currentProcess: null, allocations: [] }

  render: ->
    mainComponent = if @state.currentProcess
      ProfilerComponent { allocations: @state.allocations }
    else
      TipsComponent {}

    div {className: 'workspace'},
      SidebarComponent { currentProcess: @state.currentProcess }
      div {className: 'content-wrapper'},
        mainComponent
