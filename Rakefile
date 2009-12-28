require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gem-manage-sources"
    
    gem.summary = <<-SUMMARY
Manage your gem sources so that you can use sources that are not always available without having to 'gem sources -a' and 'gem sources -r' all the time.
    SUMMARY
    
    gem.description = <<-WTF
Manage your gem sources so that you can use sources that are not always available without having to 'gem sources -a' and 'gem sources -r' all the time.  This is especially useful if you have a gem server that lives within a firewall.    
    WTF
    
    gem.email = "britt.v.crawford@gmail.com"
    gem.homepage = "http://github.com/britt/gem-manage-sources"
    gem.authors = ["Britt Crawford"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
