require File.dirname(__FILE__) + '/../../spec_helper'

describe Gem::Commands::ManageSourcesCommand do
  before(:each) do
    @test_sources_file = Dir.tmpdir + "/test_gem_sources.yml"
    @command = Gem::Commands::ManageSourcesCommand.new
  end
  
  describe "options" do
    before(:each) do
      @command.when_invoked {}
    end
    
    describe "add" do  
      it "should be -a, --add" do
        @command.invoke("-a", "http://gems.example.com")
        @command.invoke("--add", "http://gems.example.com")
        
        @command.options[:args].should be_empty
      end
      
      it "should add the given source to :sources_to_add" do
        @command.invoke("-a", "http://gems.example.com")
        @command.options[:sources_to_add].should include("http://gems.example.com")
      end
    end
    
    describe "remove" do  
      it "should be -r, --remove" do
        @command.invoke("-r", "http://gems.example.com")
        @command.invoke("--remove", "http://gems.example.com")
        
        @command.options[:args].should be_empty
      end
      
      it "should add the given source to :sources_to_add" do
        @command.invoke("-r", "http://gems.example.com")
        @command.options[:sources_to_remove].should include("http://gems.example.com")
      end
    end
    
    describe "check" do  
      it "should be -c, --check" do
        @command.invoke("-c")
        @command.invoke("--check")
        
        @command.options[:args].should be_empty
      end      
      
      it "check_sources? should be true" do
        @command.invoke("-c")
    
        @command.options[:check_sources?].should be_true
      end
    end
    
    describe "init" do  
      it "should be -i, --init" do
        @command.invoke("-i")
        @command.invoke("--init")
        
        @command.options[:args].should be_empty
      end  
      
      it "init? should be true" do
        @command.invoke("-i")
        
        @command.options[:init?].should be_true
      end    
    end    
  end

  describe "init" do
    context "when there is no existing sources file" do
      before(:each) do
        File.delete(@test_sources_file) if File.exist?(@test_sources_file)
        Gem::Commands::ManageSourcesCommand.stub!(:sources_file).and_return(@test_sources_file)
        File.exist?(@test_sources_file).should be_false
        @command.invoke('-i')
      end
      
      it "should create ~/.gem/ruby/sources.yml" do
        File.exist?(@test_sources_file).should be_true
      end
      
      it "should add all of the existing sources" do
        pending
      end
      
      it "should check whether or not the sources are available" do
        pending
      end
      
      it "should add unavailable sources to the inactive list" do
        pending
      end
      
      it "should add available sources to the active list" do
        pending
      end
    end
    
    context "when there is already a sources file" do
    end
  end
end