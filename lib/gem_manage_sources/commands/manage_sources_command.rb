require 'rubygems/command'
require 'gem_manage_sources/sources'

module Gem
  module Commands
    class ManageSourcesCommand < Gem::Command
      include Gem::Sources
      
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
        if options[:init?]
          initialize_sources 
        elsif options[:check_sources?]
          check_sources
        elsif !options[:sources_to_add].empty?
          add_sources(options[:sources_to_add])
        elsif !options[:sources_to_remove].empty?
          remove_sources(options[:sources_to_remove])
        else
          list
        end
      end
      
      def initialize_sources
        unless File.exist?(ManageSourcesCommand.sources_file)   
          @sources = List.new(:unchecked => currently_loaded_sources)
          @sources.verify
          @sources.dump(ManageSourcesCommand.sources_file)
        end
        list
      end
      
      def check_sources
        sources.unchecked.concat(currently_loaded_sources)
        sources.verify
        sources.sync
        sources.dump(ManageSourcesCommand.sources_file)
        list
      end
      
      def add_sources(sources_to_add)
        sources_to_add.each do |source| 
          if sources.add(source) 
            puts "Added #{source} to gem sources."
          else
            puts "** #{source} Unavailable ** Added to the list of inactive sources. "
          end
        end
      end
      
      def remove_sources(sources_to_remove)
        sources_to_remove.each do |source| 
          sources.remove(source)
          puts "Removed #{source} from gem sources."
        end
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
        @sources ||= Gem::Sources::List.load_file(ManageSourcesCommand.sources_file)
      end
    end
  end
end