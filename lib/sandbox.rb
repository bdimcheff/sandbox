require 'tmpdir'
require 'sha1'

class Sandbox
  class << self
    def play(&block)
      path = generate_path
      
      FileUtils.mkdir_p(path)

      begin
        yield path
      ensure
        FileUtils.rm_r(path)
      end
    end
    
    def generate_path
      File.join(Dir.tmpdir, sandbox_dir)
    end
    
    def sandbox_dir
      sha = Digest::SHA1.hexdigest("--#{rand(20000)}---#{Time.now}--")
      
      "sandbox-#{sha}"
    end
  end
end
