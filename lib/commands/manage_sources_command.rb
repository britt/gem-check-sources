module Gem
  module Commands
    class ManageSourcesCommand < Gem::Command
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
    end
  end
end