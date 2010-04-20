require 'rubygems/command'
require 'gem_manage_sources/sources'

module Gem
  module Commands
    class CheckSourcesCommand < Gem::Command
      include Gem::Sources
      
      def self.sources_file
        File.join(ENV['HOME'], '.gem', 'ruby', 'sources.yml')
      end
      
      def initialize
        super('check_sources', 'Check which gem sources are currently available.')
        defaults.merge!(:sources_to_add => [], :sources_to_remove => [], :verbose? => false)
      end
      
      def execute
        if File.exist?(CheckSourcesCommand.sources_file)  
          check_sources
        else
          initialize_sources
        end
      end
      
      def initialize_sources
        @sources = List.new(:unchecked => currently_loaded_sources)
        @sources.verify
        @sources.sync
        @sources.dump(CheckSourcesCommand.sources_file)
      end
      
      def check_sources        
        sources.unchecked.concat(currently_loaded_sources)
        sources.verify
        sources.sync
        sources.dump(CheckSourcesCommand.sources_file)
      end
      
      def list
        say "*** CURRENT SOURCES ***"
        say ""
        say "** ACTIVE SOURCES **"
        say ""
        sources.active.each { |source| say source }
        say ""
        say "** INACTIVE SOURCES **"
        say ""
        sources.inactive.each { |source| say source }
      end
      
      private
      
      def sources
        @sources ||= Gem::Sources::List.load_file(ManageSourcesCommand.sources_file)
      end
      
      def say(message)
        super(message) unless ENV['QUIET']
      end
    end
  end
end