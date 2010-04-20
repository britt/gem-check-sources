require File.dirname(__FILE__) + '/../../spec_helper'

describe Gem::Commands::CheckSourcesCommand do
  include Gem::Sources
  
  # before(:each) do
  #   @test_sources_file = Dir.tmpdir + "/test_gem_sources.yml"
  #   @command = Gem::Commands::CheckSourcesCommand.new
  #   Gem::Commands::ManageSourcesCommand.stub!(:sources_file).and_return(@test_sources_file)
  # end
  # 
  # after(:each) do
  #   File.delete(@test_sources_file) if File.exist?(@test_sources_file)
  # end

  describe "check" do
    context "when the sources file does not exist" do
      it "should create ~/.gem/ruby/sources.yml" do   
        pending     
        File.exist?(@test_sources_file).should be_true
      end
      
      it "should add all of the existing sources" do
        pending
        sources = Gem::Sources::List.load_file(@test_sources_file)
        @sources.each do |source|
          sources.all.should include(source)
        end
      end
            
      it "should add unavailable sources to the inactive list" do
        pending
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.active.should == ['http://active.example.com']
      end
      
      it "should add available sources to the active list" do
        pending
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.inactive.should == ['http://inactive.example.com']
      end
    end
    
    context "when the sources file already exists" do    
      it "should load the sources list from ~/.gem/ruby/sources.yml" do
        pending
      end
      
      it "should should add any new sources that have been added using 'gem source add'" do
        pending
        @list.all.should include('http://another.example.com')
      end

      it "should add unavailable sources to the inactive list" do 
        pending
        @list.inactive.sort.should == ['http://inactive.example.com', 'http://another.example.com'].sort
      end

      it "should add available sources to the active list" do
        pending
        @list.active.should == ['http://active.example.com']
      end
    end
  end
end