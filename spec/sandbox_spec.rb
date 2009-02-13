require File.dirname(__FILE__) + '/spec_helper'

describe "Sandbox" do
  it "returns a path in the tmp directory" do
    flexmock(Sandbox, :sandbox_dir => 'foo')
    flexmock(Dir, :tmpdir => '/bar')

    Sandbox.generate_path.should == '/bar/foo'
  end

  it "returns different paths for subsequent calls to sandbox_dir" do
    dir1 = Sandbox.sandbox_dir
    dir2 = Sandbox.sandbox_dir

    dir1.should_not == dir2
  end
  
  context "no errors" do
    it "cleans up after itself" do
      path = Sandbox.play do |p|
        File.exist?(p).should be_true
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
end
