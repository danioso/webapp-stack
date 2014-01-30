
# Bower libraries
React = require '../../app/bower/react/react.min'

# Local libraries


###
# Todo
###

TodoList = React.createClass
	
	render: -> 

		createItem = (itemText)-> 
			`<li>{itemText}</li>`
			
		`<ul>{this.props.items.map(createItem)}</ul>`


TodoApp = React.createClass 
	
	getInitialState: ->

		{
			items: []
			text: ''
			message:'Field is empty o.O'
			messageStyle: 
				display: 'none'
		}

	onChange: (e)-> 

		@setState {text: e.target.value}

	handleSubmit: (e)->

		e.preventDefault()
		
		# Add item
		if this.state.text isnt ''

			nextItems = @state.items.concat [this.state.text]
			nextText = ''
			
			@setState {
				items: nextItems
				text: nextText
				messageStyle: 
					display: 'none'
			}
		
		# Item is empty, show error message	
		else 

			@setState { 
				messageStyle: 
					display: 'block'
			}
			

	render: -> 

		`(
			<div className="todo"> 
				<h3>Tareas ({this.state.items.length})</h3>
				<div className="message" style={this.state.messageStyle}>{this.state.message}</div>
				<form onSubmit={this.handleSubmit}>
					<input onChange={this.onChange} value={this.state.text} />
					<button>{'Add #' + (this.state.items.length + 1)}</button>
				</form>
				<div className="clr"></div>
				<TodoList items={this.state.items} />
			</div>
		)`

module.exports = TodoApp
