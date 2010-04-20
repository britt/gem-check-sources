require File.dirname(__FILE__) + '/../../spec_helper'

describe Gem::Commands::CheckSourcesCommand do
  include Gem::Sources
  
  before(:each) do
    # Dump the sources file in a temp dir so its easy to clean up.
    @test_sources_file = Dir.tmpdir + "/test_gem_sources.yml"
    Gem::Commands::CheckSourcesCommand.stub!(:sources_file).and_return(@test_sources_file)
    
    @command = Gem::Commands::CheckSourcesCommand.new
  end
  
  after(:each) do
    File.delete(@test_sources_file) if File.exist?(@test_sources_file)
  end
  
  def stub_system_gem_sources_command(command, sources)
    command.stub!(:currently_loaded_sources).and_return(sources)
  end
  
  def stub_source_checking(command, list, &block)
    list.stub!(:source_available?, &block)
    Gem::Sources::List.stub!(:new).and_return(list)
    command.stub!(:sources).and_return(list)
  end
  
  describe "check" do
    context "when the sources file does not exist" do
      before(:each) do
        @sources = ['http://active.example.com','http://inactive.example.com']
        stub_system_gem_sources_command(@command, @sources)

        @list = Gem::Sources::List.new(:unchecked => @sources)
        stub_source_checking(@command, @list) { |source| source == 'http://active.example.com' }
      end
      
      it "should create ~/.gem/ruby/sources.yml" do  
        @list.stub!(:sync) 
        @command.invoke      
        File.exist?(@test_sources_file).should be_true
      end
      
      it "should add all of the existing sources" do
        @list.stub!(:sync)
        @command.invoke      
        sources = Gem::Sources::List.load_file(@test_sources_file)
        @sources.each do |source|
          sources.all.should include(source)
        end
      end
            
      it "should add unavailable sources to the inactive list" do
        @list.stub!(:sync) 
        @command.invoke
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.active.should == ['http://active.example.com']
      end
      
      it "should add available sources to the active list" do
        @list.stub!(:sync) 
        @command.invoke
        sources = Gem::Sources::List.load_file(@test_sources_file)
        sources.inactive.should == ['http://inactive.example.com']
      end
      
      it "should synchronize the system source list with the available sources" do
        @list.should_receive(:sync).once
        @command.invoke
      end
    end
    
    context "when the sources file already exists" do    
      def invoke_with_stubbed_synchronization
        @initial_list.stub!(:sync)         
        @command.invoke
        @list = Gem::Sources::List.load_file(@test_sources_file)
      end
      
      before(:each) do
        #Create a source list
        @sources = ['http://active.example.com','http://inactive.example.com', 'http://another.example.com']
        @initial_list = Gem::Sources::List.new(:active => ['http://active.example.com'], :inactive => ['http://inactive.example.com'])
        @initial_list.dump(Gem::Commands::CheckSourcesCommand.sources_file)
        
        stub_system_gem_sources_command(@command, @sources)
        stub_source_checking(@command, @initial_list) { |source| source == 'http://active.example.com' } 
      end
      
      it "should load the sources list from ~/.gem/ruby/sources.yml" do
        invoke_with_stubbed_synchronization
        @list.all.should include('http://active.example.com')
        @list.all.should include('http://inactive.example.com')
      end
      
      it "should should add any new sources that have been added using 'gem source add'" do
        invoke_with_stubbed_synchronization
        @list.all.should include('http://another.example.com')
      end

      it "should add unavailable sources to the inactive list" do 
        invoke_with_stubbed_synchronization
        @list.inactive.sort.should == ['http://inactive.example.com', 'http://another.example.com'].sort
      end

      it "should add available sources to the active list" do
        invoke_with_stubbed_synchronization
        @list.active.should == ['http://active.example.com']
      end
      
      it "should add sources to the list only once" do
        invoke_with_stubbed_synchronization
        @list.all.should == @list.all.uniq
      end
      
      it "should synchronize the system source list with the available sources" do
        @initial_list.should_receive(:sync).once
        @command.invoke
      end
    end
  end
end