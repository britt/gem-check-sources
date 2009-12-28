module Gem
  module Sources
    def self.load_existing_sources
      sources_text = `gem sources`
    end
  end
end