require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the delete_softly plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Echoe'
Echoe.new('delete_softly', '0.0.2') do |p|
  p.description = "Add soft delete functionality to your ActiveRecord models"
  p.url = "http://github.com/bterkuile/delete_softly"
  p.author = "Benjamin ter Kuile"
  p.email = "bterkuile@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.runtime_dependencies = ["meta_where"]
  p.development_dependencies = []
end

desc 'Generate documentation for the delete_softly plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DeleteSoftly'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
