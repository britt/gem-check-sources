require 'rubygems/command'

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
        list
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
        puts "*** CURRENT SOURCES ***"
        puts ""
        puts "** ACTIVE SOURCES **"
        puts ""
        sources.active.each { |source| puts source }
        puts ""
        puts "** INACTIVE SOURCES **"
        puts ""
        sources.inactive.each { |source| puts source }
      end
      
      private
      
      def sources
        @sources ||= Gem::Sources::List.load_file(CheckSourcesCommand.sources_file)
      end
    end
  end
end