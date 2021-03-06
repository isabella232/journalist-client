_                  = require 'lodash'
React              = require 'react-atom-fork'
WorkspaceComponent = require 'src/components/workspace_component'
{Tail}             = require 'tail'

module.exports =
class Journalist
  reset: ->
    @allocations = {}
    @allocationsNeedUpdating = false

  startProfiler: ->
    @workspace = React.renderComponent(new WorkspaceComponent(), document.body)
    setInterval(@updateWorkspace, 500)

  switchProcess: (process) ->
    return if @workspace.state.currentProcess?.pid == process.pid

    # Reset all the things
    @reset()

    # Unwatch if we're already watching, and start tailing the new file.
    @tail?.unwatch()

    @tail = new Tail("/tmp/journalist-#{ process.pid }")
    @tail.on 'line', @handleLine

    @workspace.setState
      allocations: []
      currentProcess: process

  handleLine: (data) =>
    try
      profileEvent = JSON.parse(data)
    catch err
      console.log err
      console.log data


    switch profileEvent.event
      when "newobj"
        @allocations[profileEvent.type] ||= 0
        @allocations[profileEvent.type] += profileEvent.total
        @allocationsNeedUpdating = true

  updateWorkspace: =>
    return if @updatingWorkspace

    @updatingWorkspace = true
    newState = {}

    if @allocationsNeedUpdating
      @allocationsNeedUpdating = false

      allocationTuples = []
      for type, count of @allocations
        allocationTuples.push([type, count])

      newState.allocations = _.sortBy(allocationTuples, (val) -> -val[1])

    @workspace.setState newState
    @updatingWorkspace = false
