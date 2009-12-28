require 'uri'
require 'net/http'

module Gem
  module Sources
    def currently_loaded_sources
      `gem sources`.split("\n").select { |s| s.start_with?('http') }
    end
    
    def source_available?(host)
      uri = URI.parse(host)
      gemspec_path = uri.path[-1,1] == '/' ? "gems/latest_specs.4.8.gz" : "/gems/latest_specs.4.8.gz"
      response = nil
      Net::HTTP.start(uri.host, uri.port) {|http|
        response = http.head(gemspec_path)
      }
      response.is_a?(Net::HTTPOK)
    end
    
    class List
      attr_accessor :active, :inactive
    
      def self.load_file(file_name)
        sources = YAML.load_file(file_name)
        List.new(sources[:active], sources[:inactive])
      end
      
      def initialize(active = [], inactive = [])
        self.active = active
        self.inactive = inactive
      end
    
      def all
        active + inactive
      end
      
      def to_h
        {:active => active, :inactive => inactive}
      end
    end
  end
end