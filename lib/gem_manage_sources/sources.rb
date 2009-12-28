require 'uri'
require 'net/http'

module Gem
  module Sources
    def currently_loaded_sources
      `gem sources`.split("\n").select { |s| s.start_with?('http') }
    end
    
    class List      
      attr_accessor :active, :inactive, :unchecked
    
      def self.load_file(file_name)
        List.new(YAML.load_file(file_name))
      end
      
      def initialize(sources = {})
        self.active = sources[:active] || []
        self.inactive = sources[:inactive] || []
        self.unchecked = sources[:unchecked] || []
      end
    
      def verify
        @active, @inactive = all.partition { |source| source_available?(source) }
      end
    
      def sync
      end
    
      def all
        (active + inactive + unchecked).uniq
      end
      
      def to_h
        {:active => active, :inactive => inactive}
      end
      
      def dump(file_name)
        File.open(file_name, 'w') do |sources_file|
          YAML.dump(to_h, sources_file)
        end
      end
      
      def size
        all.size
      end
      
      private
      
      def source_available?(host)
        uri = URI.parse(host)
        gemspec_path = uri.path[-1,1] == '/' ? "gems/latest_specs.4.8.gz" : "/gems/latest_specs.4.8.gz"
        response = nil
        Net::HTTP.start(uri.host, uri.port) {|http|
          response = http.head(gemspec_path)
        }
        response.is_a?(Net::HTTPOK)
      end
      
      def add_source(source)
        system("gem source -a #{source}")
      end

      def remove_source(source)
        system("gem source -r #{source}")
      end
    end
  end
end