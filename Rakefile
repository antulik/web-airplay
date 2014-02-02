require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :release do
  system('/usr/local/bin/platypus -P deploy/WebAirplay.platypus -y release/WebAirplay.app')
end
