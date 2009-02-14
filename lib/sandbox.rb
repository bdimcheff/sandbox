require 'tmpdir'
require 'sha1'

# Represents a temporary sandbox for testing that relies on the
# filesystem.
class Sandbox
  attr_accessor :path

  # Executes the block and yields the path to the sandbox directory.
  # Cleans up the sandbox after the block is complete.
  def self.play(path = nil, &block)
    sandbox = Sandbox.new(path)
    
    begin
      yield sandbox.path
    ensure
      sandbox.close
    end
  end

  # Creates a new Sandbox with an optional path.  Generates a random
  # path in Dir.tmpdir if path is unspecified.
  def initialize(path = nil)
    self.path = path || generate_path
    
    FileUtils.mkdir_p(self.path)
  end
  
  # Cleans up the sandbox by removing the path
  def close
    FileUtils.rm_r(path)
  end

  private
  def generate_path
    File.join(Dir.tmpdir, sandbox_dir)
  end
  
  def sandbox_dir
    sha = Digest::SHA1.hexdigest("--#{rand(20000)}---#{Time.now}--")
    
    "sandbox-#{sha}"
  end
end
