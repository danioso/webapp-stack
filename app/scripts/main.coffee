
# Bower libraries
React = require '../../app/bower/react/react.min'

# Local libraries
TodoApp = require './app' 

###
# Main App
###
React.renderComponent `<TodoApp />`, document.getElementById('app')
