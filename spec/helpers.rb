
BUILD_DIR=File.expand_path('./target/build')
SYSTEM_RUBY = "#{BUILD_DIR}/tools/ruby-2.1.5"

module Helpers
  # sets the environment via set-env.bat before running the command
  # and returns whatever the cmd writes (captures both stdout and stderr)
  def run_cmd(cmd)
    `"#{BUILD_DIR}/set-env.bat" >NUL && #{cmd} 2>&1`
  end
  # similar to #run_cmd, but uses system and returns the exit code
  # (both stdout and stderr are redirected to acceptance.log)
  def system_cmd(cmd)
    system "echo \"--> Running command: '#{cmd}':\" >>#{LOGFILE}"
    unless (status = system "#{BUILD_DIR}/set-env.bat >NUL && #{cmd} >>#{LOGFILE} 2>&1")
      puts "Command failed: '#{cmd}'\n  --> see #{LOGFILE} for details"
    end
    status
  end
  # converts the path to using backslashes
  def convert_slashes(path)
    path.gsub('/', '\\').gsub('\\', '\\\\\\\\') #eek
  end
  # runs #system_cmd and checks for success (i.e. exit status 0)
  def cmd_succeeds(cmd)
    system_cmd(cmd).should be_true
  end
  # checks if the given line is contained in the environment
  def env_match(line)
    run_cmd("set").should match(/^#{convert_slashes(line)}$/)
  end
  # checks if the given gem is installed at version
  def gem_installed(name, version, gem_cmd = "#{SYSTEM_RUBY}/bin/gem")
    run_cmd("#{gem_cmd} list").should match("#{name} \\(#{version}\\)")
  end
end