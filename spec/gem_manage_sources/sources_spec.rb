require File.dirname(__FILE__) + '/../spec_helper'

describe Gem::Sources do
  include Gem::Sources
  
  describe "#currently_loaded_sources" do
    it "should load all of the sources from 'gem sources'" do
      currently_loaded_sources.should == `gem sources`.split("\n").select { |s| s.start_with?('http') }
    end
  end
    
  describe Gem::Sources::List do
    before(:each) do
      @sources = {
        :active => ['http://active.example.com'],
        :inactive => ['http://inactive.example.com']
      }
      @list = Gem::Sources::List.new(@sources[:active], @sources[:inactive])
    end
    
    describe "##load_file" do
      it "should load the given YAML" do
        @test_sources_file = Dir.tmpdir + "/test_gem_sources.yml"        
        File.open(@test_sources_file, 'w+') {|out| YAML.dump(@sources, out) }
        
        file_list = Gem::Sources::List.load_file(@test_sources_file)
        file_list.active.should == @list.active
        file_list.inactive.should == @list.inactive
        
        File.delete @test_sources_file
      end
    end
    
    describe "#all" do
      it "should include both active and inactive sources" do
        @list.all.sort.should == ['http://active.example.com', 'http://inactive.example.com'].sort
      end
    end
    
    describe "#to_h" do
      it "should serialize to a hash" do
        @list.to_h.should == @sources
      end
    end
  end
end