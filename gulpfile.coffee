'use strict'

# Gulp
gulp	 		= require('gulp')
util 			= require('gulp-util')
watch	 		= require('gulp-watch')
rename 		= require('gulp-rename')
header 		= require('gulp-header')

# Preprocessors
coffee	 	 = require('gulp-coffee')
react 		 = require('gulp-react')
browserify = require('gulp-browserify')
stylus	 	 = require('gulp-stylus')
jade	 	   = require('gulp-jade')

# Server, livereload
ecstatic 	 = require('ecstatic')
http 		   = require('http')
embedlr 	 = require('gulp-embedlr')
livereload = require('gulp-livereload')
server 		 = require('tiny-lr')()

###
# Styles
###
gulp.task 'styles', ->
	gulp.src('app/styles/**/*.styl')
		  .pipe(stylus())
			.pipe(gulp.dest( 'dist/styles/' ))
			.pipe(livereload(server))

###
# Scripts
###
gulp.task 'scripts', ->
	gulp.start('browserfy')

gulp.task 'coffee', ->
	gulp.src(['app/scripts/**/*.coffee','!app/scripts/bower/*'])
			.pipe(coffee( bare: true ))
			.pipe(header('/** <%= tag %> */\n\n', { tag: '@jsx React.DOM'} )) # Add React JXS header tag
			.pipe(rename((dir, base, ext) ->
				return base + '.jsx';
			))
			.pipe(gulp.dest( '.tmp/jsx/' ))

gulp.task 'jsx', ['coffee'], ->
	gulp.src('.tmp/jsx/**/*.jsx')
			.pipe(react())
			.pipe(gulp.dest('.tmp/scripts/'))

gulp.task 'browserfy', ['jsx'], ->
	gulp.src('.tmp/scripts/main.js')
			.pipe(browserify(
				insertGlobals: true
				debug: !util.env.production
      ))
			.pipe(gulp.dest('dist/scripts/'))
			.pipe(livereload(server))

###
# Templates HTML
###
gulp.task 'templates', ->
	gulp.src('app/*.jade')
			.pipe(jade())
			.pipe(embedlr()) # Add livereload script
			.pipe(gulp.dest('dist/'))
			.pipe(livereload(server))

###
# Default task
###
gulp.task 'default', ->
	gulp.start('styles', 'templates', 'scripts')

###
# Static server, livereload and watch changes
###
gulp.task 'watch', ->
	gulp.start('default')

	# Create static server
	http.createServer(
		ecstatic({ root: __dirname + '/dist' })
	).listen(8080)

	# Listen on port 35729
	server.listen 35729, (err) ->
		return console.log(err) if err

		gulp.watch('app/styles/**/*.styl', ['styles']) # Watch .styl files
		gulp.watch('app/scripts/**/*.coffee', ['scripts']) # Watch .coffee files
		gulp.watch(['app/*.jade','app/templates/**/*.jade'], ['templates']) # Watch .jade files