module Gem
  module Commands
    class ManageSourcesCommand < Gem::Command
      def self.sources_file
        File.join(ENV['HOME'], '.gem', 'ruby', 'sources.yml')
      end
      
      def initialize
        super('manage-sources', 'Manage the sources RubyGems use to search for gems. (USE INSTEAD OF: sources)')
        defaults.merge!(:sources_to_add => [], :sources_to_remove => [], :check_sources? => false, :init? => false)
        
        add_option('-a', '--add SOURCE_URL', 'Add a gem source') do |value, options|
          options[:sources_to_add] << value
        end
        
        add_option('-r', '--remove SOURCE_URL', 'Remove a gem source') do |value, options|
          options[:sources_to_remove] << value
        end
        
        add_option('-c', '--check', 'Check gem sources. This will add or remove sources depending on availability.') do |value, options|
          options[:check_sources?] = true
        end
        
        add_option('-i', '--init', 'Generate the sources.yml file from your existing gem sources.') do |value, options|
          options[:init?] = true
        end
      end
      
      def execute
        initialize_sources if options[:init?]
        check_sources if options[:check_sources?]
        add_sources(options[:sources_to_add])
        remove_sources(options[:sources_to_remove])
      end
      
      def initialize_sources
        unless File.exist?(ManageSourcesCommand.sources_file)
          f = File.open(ManageSourcesCommand.sources_file, 'w+')
          f.close
        end
      end
      
      def check_sources
        raise NotImplementedError
      end
      
      def add_sources(sources)
      end
      
      def remove_sources(sources)
      end
    end
  end
end