controllers = Dir["#{File.dirname(__FILE__)}/../../lib/controllers/**/*.rb"]
views = Dir["#{File.dirname(__FILE__)}/../../lib/views/**/*.rb"]
models = Dir["#{File.dirname(__FILE__)}/../../lib/models/**/*.rb"]
queries = Dir["#{File.dirname(__FILE__)}/../../lib/queries/**/*.rb"]

[*controllers, *views, *models, *queries].each{ require(_1) }