require "rubygems"
require "sinatra"
require File.expand_path(File.join('..', 'stumble_score'), __FILE__)


get '/' do
  address = params[:address]
  if address
  	location = StumbleScore::Location.new(address)
  	 message = "<!doctype html>
  <html>
  <head></head>
  <body>
    <h1>Welcome to StumbleScore</h1>
    <p>StumbleScore for #{address}:</p>
  	<p>Bar count: #{location.bar_count}</p>
  	<p>StumbleScore: #{location.score}</p>
  	<p>Classified as: #{location.classification}</p><ul>"
  	location.bar_names.each do |place|
  		message = message + "<li>#{place}</li>"
  	end
  	message = message + "</ul></body></head>"
  else
  	message = "<p>Please specify an address parameter to search.</p>"
  end
  message
end

