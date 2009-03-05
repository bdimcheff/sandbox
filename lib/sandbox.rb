require 'tmpdir'
require 'sha1'

# Represents a temporary sandbox for testing that relies on the
# filesystem.
class Sandbox
  attr_accessor :path

  # Executes the block and yields the path to the sandbox directory.
  # Cleans up the sandbox after the block is complete.
  # == Options
  # [+:path+] the path to use. default:  generate one in Dir.tmpdir
  # [+:cd+] change directory with Dir.chdir to the temp directory
  def self.play(options = {}, &block)
    sandbox = Sandbox.new(options[:path])

    begin
      if options[:cd]
        Dir.chdir(sandbox.path) do
          yield sandbox.path
        end
      else
        yield sandbox.path
      end
    ensure
      sandbox.close
    end
  end

  # Creates a new Sandbox with an optional path.
  # == Parameters
  # [+path+] The path to use.  default:  generate one in Dir.tmpdir
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
