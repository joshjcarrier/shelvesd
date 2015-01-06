require 'sinatra'

set :bind, '0.0.0.0'

configure :production do
  set :port, 8123
end

get '/', :provides => 'html' do
  '<html><body><a href=\'/api/v1/lights\'>/api/v1/lights</a><br/><a href=\'/api/v1/shelves\'>/api/v1/shelves</a></body></html>'
end

get '/api/v1/lights', :provides => 'json' do
  'lights on!'
end

get '/api/v1/shelves', :provides => 'json' do
  'Hello world!'
end
