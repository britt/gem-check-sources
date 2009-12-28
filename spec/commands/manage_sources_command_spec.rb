require File.dirname(__FILE__) + '/../spec_helper'

describe Gem::Commands::ManageSourcesCommand do
  before(:each) do
    @command = Gem::Commands::ManageSourcesCommand.new
    @command.when_invoked {}
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
    end
    
    describe "init" do  
      it "should be -i, --init" do
        @command.invoke("-i")
        @command.invoke("--init")
        
        @command.options[:args].should be_empty
      end      
    end    
  end
end