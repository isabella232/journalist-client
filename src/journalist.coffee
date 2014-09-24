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
      allocations: {}
      currentProcess: process

  handleLine: (data) =>
    [eventType, rawEventData] = data.split(': ')

    eventData = {}
    rawEventData?.split(' ').eachSlice 2, ([key, val]) ->
      eventData[key] = val

    switch eventType
      when "newobj"
        count = parseInt(eventData.count, 10)
        type  = eventData.type
        @allocations[type] ||= 0
        @allocations[type] += count
        @allocationsNeedUpdating = true

  updateWorkspace: =>
    return if @updatingWorkspace

    @updatingWorkspace = true
    newState = {}

    if @allocationsNeedUpdating
      @allocationsNeedUpdating = false
      newState.allocations = _.clone(@allocations)

    @workspace.setState newState
    @updatingWorkspace = false
