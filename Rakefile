require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gem-manage-sources"
    
    gem.summary = <<-SUMMARY
A replacement for the 'gem sources' command that allows you to easily use sources that may not always be available (e.g. inside a firewall).
    SUMMARY
    
    gem.description = <<-WTF
gem-manage-sources is a replacement for the 'gem sources' command that allows you to easily use sources that may not always be available.

Imagine you work at a company that hosts its own gem server within the corporate network.  At work you need to install and update gems hosted on the corporate
server, but when you take your laptop home and try to work on some side projects (that don't use the company gems) all your remote gem commands fail.  So, you end up typing 'gem sources -a' and 'gem sources -r' a lot.

gem-manage-sources solves this problem by maintaining two list of gem servers (active and inactive) and checking whether or not gem servers are available.  If a server is unavailable it gets put on the inactive list and removed form your gem sources.  When it becomes availabl again it gets re-added to your list of gem sources.    
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
