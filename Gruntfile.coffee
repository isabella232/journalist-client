path        = require 'path'
packageJson = require './package.json'
{exec}      = require 'child_process'

module.exports = (grunt) ->
  {cp, rm} = require('./tasks/task-helpers')(grunt)

  atomBinary = path.join('binaries', 'Atom.app')
  appDir     = path.join(atomBinary, 'Contents', 'Resources', 'app')

  coffeeConfig =
    glob_to_multiple:
      expand: true
      src: ['src/**/*.coffee']
      dest: appDir
      ext: '.js'

  stylusConfig =
    glob_to_multiple:
      expand: true
      src: ['static/**/*.styl']
      dest: appDir
      ext: '.css'

  watchConfig =
    html:
      files: ['static/index.html', 'static/main.js']
      tasks: ['static']
    stylus:
      files: stylusConfig.glob_to_multiple.src
      tasks: ['stylus']
    coffee:
      files: coffeeConfig.glob_to_multiple.src
      tasks: ['coffee']

  grunt.initConfig
    coffee: coffeeConfig
    stylus: stylusConfig
    watch: watchConfig
    'download-atom-shell':
      version: '0.16.3'
      outputDir: 'binaries'

  # Dependencies
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-download-atom-shell')

  grunt.registerTask('compile', ['coffee', 'stylus'])

  grunt.registerTask 'run', 'Runs the application', ->
    exec("open #{atomBinary}")

  grunt.registerTask 'static', 'Copy the static assets', ->
    cp 'static', appDir, filter: /.+\.styl$/

  grunt.registerTask 'deps', 'Copy the node_module dependencies', ->
    for dependency of packageJson["dependencies"]
      dependencyPath = path.join('node_modules', dependency)
      cp dependencyPath, path.join(appDir, dependencyPath)

  grunt.registerTask 'clean', 'Remove build artifacts', ->
    rm appDir

  defaultTasks = [
    'download-atom-shell',
    'clean',
    'compile',
    'static',
    'deps',
    'run',
    'watch'
  ]

  grunt.registerTask('default', defaultTasks)
