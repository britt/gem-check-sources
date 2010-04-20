$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'gem_check_sources'
require 'spec'
require 'spec/autorun'
require 'pp'
require 'tmpdir'

ENV['QUIET'] = 'true'

Spec::Runner.configure do |config|
  
end
