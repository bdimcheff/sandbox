require File.dirname(__FILE__) + '/spec_helper'

describe "Sandbox" do
  context "when there are no errors in the block" do
    it "cleans up after itself" do
      path = Sandbox.play do |p|
        File.exist?(p).should be_true
        File.ftype(p).should == 'directory'
        p
      end

      File.exist?(path).should be_false
    end

    it "changes directories when :cd => true is specified" do
      path = Sandbox.play(:cd => true) do |p|
        File.exist?(p).should be_true
        File.ftype(p).should == 'directory'
        File::Stat.new(Dir.pwd).ino.should == File::Stat.new(p).ino
        p
      end

      File.exist?(path).should be_false
    end

    it "uses the specified path when :path is specified" do
      tmp = Dir.tmpdir
      path = File.join(tmp, 'sandbox-test')
      
      Sandbox.play(:path => path) do |p|
        p.should == path
      end
    end
  end
  
  context "when an exception is raised" do
    it "cleans up after itself" do
      lambda {
        Sandbox.play do |p|
          @path = p
          File.exist?(p).should be_true
          raise "boom"
        end
      }.should raise_error

      File.exist?(@path).should be_false
    end
  end
end
