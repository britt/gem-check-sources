require File.dirname(__FILE__) + '/../../spec_helper'

describe Gem::Commands::ManageSourcesCommand do
  include Gem::Sources
  
  before(:each) do
    @test_sources_file = Dir.tmpdir + "/test_gem_sources.yml"
    @command = Gem::Commands::ManageSourcesCommand.new
  end
  
  after(:each) do
    File.delete(@test_sources_file) if File.exist?(@test_sources_file)
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
        create_test_sources_file('http://active.example.com','http://inactive.example.com')
      end
      
      it "should create ~/.gem/ruby/sources.yml" do        
        File.exist?(@test_sources_file).should be_true
      end
      
      it "should add all of the existing sources" do
        sources = Gem::Sources::List.load_file(@test_sources_file)
        @sources.each do |source|
          sources.all.should include(source)
        end
      end
            
      it "should add unavailable sources to the inactive list" do
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.active.should == ['http://active.example.com']
      end
      
      it "should add available sources to the active list" do
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.inactive.should == ['http://inactive.example.com']
      end
    end
  end

  describe "check" do
    before(:each) do
      create_test_sources_file('http://active.example.com','http://inactive.example.com')
      @sources << 'http://another.example.com'
      @command.invoke('-c')
      @list = Gem::Sources::List.load_file(@test_sources_file)    
    end
    
    it "should should add any new sources that have been added using 'gem source add'" do
      @list.all.should include('http://another.example.com')
    end
    
    it "should add unavailable sources to the inactive list" do 
      @list.inactive.should.sort.should == ['http://inactive.example.com', 'http://another.example.com'].sort
    end
    
    it "should add available sources to the active list" do
      @list.active.should == ['http://active.example.com']
    end
  end
  
  def create_test_sources_file(*sources)
    Gem::Commands::ManageSourcesCommand.stub!(:sources_file).and_return(@test_sources_file)
    File.exist?(@test_sources_file).should be_false
            
    @sources = sources
    @command.stub!(:currently_loaded_sources).and_return(@sources)
    @command.stub!(:source_available?) do |source|
      source == 'http://active.example.com'
    end
    @command.invoke('-i')
  end
end