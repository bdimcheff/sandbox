require File.dirname(__FILE__) + '/spec_helper'

describe "Sandbox" do
  context "no errors" do
    it "cleans up after itself" do
      path = Sandbox.play do |p|
        File.exist?(p).should be_true
        File.ftype(p).should == 'directory'
        p
      end

      File.exist?(path).should be_false
    end
  end
  
  context "exception raised" do
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

  context "optional path supplied" do
    it "uses the specified path" do
      tmp = Dir.tmpdir
      path = File.join(tmp, 'sandbox-test')
      
      Sandbox.play(path) do |p|
        p.should == path
      end
    end
  end
end
