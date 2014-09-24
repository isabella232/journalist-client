fs  = require 'fs'

React       = require 'react-atom-fork'
Reactionary = require 'reactionary-atom-fork'
{div, span} = Reactionary
{ul, li}    = Reactionary

module.exports =
SidebarComponent = React.createClass
  displayName: 'SidebarComponent'
  render: ->
    div {className: 'sidebar'},
      ul {className: 'available-profiles'},
        ProfilersListComponent {}

ProfilersListComponent = React.createClass
  displayName: 'ProfilersListComponent'
  render: ->
    li {className: 'profilers'},
      LocalProfilersListComponent()

  componentWillMount: ->

LocalProfilersListComponent = React.createClass
  PID_MATCHER: /^journalist-(\d+)$/
  displayName: 'LocalProfilersListComponent',
  getInitialState: ->
    {profiles: []}

  render: ->
    nodes = @state.profiles.map (profile) ->
      LocalProfilerComponent(profile)

    li {className: 'local-profilers'},
      span {className: 'profiler-type' },
        "Local",
      ul {className: 'local-profilers-list'},
        nodes

  componentWillMount: ->
    @findLocalProfiles()
    setInterval(@findLocalProfiles, 1000);

  findLocalProfiles: ->
    files    = fs.readdirSync('/tmp')
    profiles = []

    for file in files
      match = file.match(@PID_MATCHER)
      continue unless match

      profiles.push({pid: match[1], key: "local-profile-#{ match[1] }"})

    @setState profiles: profiles.sort (a, b) ->
      return a.pid - b.pid

LocalProfilerComponent = React.createClass
  displayName: 'LocalProfilerComponent'
  render: ->
    classes = ['local-profiler']
    # classes.push 'selected' if @state.selectedPid == @props.pid

    li {className: classes, onClick: @selectProfile},
      "Process ID #{ @props.pid }"

  selectProfile: ->
    window.journalist.switchProcess(@props)
