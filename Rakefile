%w{ bundler/setup rubygems fileutils uri net/https tmpdir digest/md5 }.each do |file|
  require file
end

VERSION = '0.3-SNAPSHOT'
BASE_DIR = File.expand_path('.', File.dirname(__FILE__)) 
TARGET_DIR  = "#{BASE_DIR}/target" 
BUILD_DIR   = "#{BASE_DIR}/target/build"
CACHE_DIR   = "#{BASE_DIR}/target/cache"
ZIP_EXE = 'C:\Program Files\7-Zip\7z.exe'


desc 'cleans all output and cache directories'
task :clean do 
  FileUtils.rm_rf TARGET_DIR
end

desc 'downloads required resources and builds the devpack binary'
task :build do
  recreate_dirs
  download_tools
  move_ruby
  copy_files
  install_gems
  run_tests "integration"
end

desc 'run integration tests'
task :test do
  run_tests "integration"
end

desc 'assemble `target/build` into a .7z package'
task :package do
  assemble_package
end

# runs the install step with the given name (internal task for debugging)
task :run, [:method_name] do |t, args|
  self.send(args[:method_name].to_sym)
end

def run_tests(level)
  Bundler.with_clean_env do
    sh "rspec spec/#{level} -fd -c"
  end
end

def recreate_dirs
  FileUtils.rm_rf BUILD_DIR
  %w{ home install repo tools }.each do |dir|
    FileUtils.mkdir_p "#{BUILD_DIR}/#{dir}"
  end
  FileUtils.mkdir_p CACHE_DIR
end

def copy_files
  FileUtils.cp_r Dir.glob("#{BASE_DIR}/files/*"), "#{BUILD_DIR}"
end

def download_tools
  [
    %w{ skylink.dl.sourceforge.net/project/conemu/Preview/ConEmuPack.150305.7z                              conemu },
    %w{ github.com/mridgers/clink/releases/download/0.4.4/clink_0.4.4_setup.exe                             clink },
    %w{ c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.zip                                        sublimetext2 },
    %w{ github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20141217/PortableGit-1.9.5-preview20141217.7z   portablegit },
    %w{ dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.1-x64-mingw32.7z                                     ruby },
    %w{ dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe                 devkit },
    %w{ switch.dl.sourceforge.net/project/kdiff3/kdiff3/0.9.96/KDiff3Setup_0.9.96.exe                       kdiff3
        kdiff3.exe },
    %w{ the.earth.li/~sgtatham/putty/0.63/x86/putty.zip                                                     putty }
  ]
  .each do |host_and_path, target_dir, includes = ''|
    download_and_unpack "http://#{host_and_path}", "#{BUILD_DIR}/tools/#{target_dir}", includes.split('|')    
  end
end

# move ruby to a shorter path to reduce the likeliness that a gem fails to install due to max path length
def move_ruby
  FileUtils.mv "#{BUILD_DIR}/tools/ruby/ruby-2.2.1-x64-mingw32", "#{BUILD_DIR}/tools/ruby-2.2.1"
  FileUtils.rm_rf "#{BUILD_DIR}/tools/ruby"
end

def install_gems
  Bundler.with_clean_env do
    # XXX: DOH! - with_clean_env does not clear GEM_HOME if the rake task is invoked using `bundle exec`, 
    # which results in gems being installed to your current Ruby's GEM_HOME rather than the Ruby DevPack's GEM_HOME!!! 
    fail "must run `rake build` instead of `bundle exec rake build`" if ENV['GEM_HOME']
    command = "#{BUILD_DIR}/set-env.bat \
      && gem install bundler -v 1.8.4 --no-ri --no-rdoc"
    fail "gem installation failed" unless system(command)
  end
end

def reset_git_user
  Bundler.with_clean_env do
    command = "#{BUILD_DIR}/set-env.bat \
      && git config --global --unset user.name \
      && git config --global --unset user.email"
    fail "resetting dummy git user failed" unless system(command)
  end
end

def assemble_package
  reset_git_user
  pack BUILD_DIR, "#{TARGET_DIR}/ruby-devpack-#{VERSION}.7z"
end

def download_and_unpack(url, target_dir, includes = []) 
  Dir.mktmpdir do |tmp_dir| 
    outfile = "#{tmp_dir}/#{File.basename(url)}"
    download(url, outfile)
    unpack(outfile, target_dir, includes)
  end
end

def download(url, outfile)
  puts "checking cache for '#{url}'"
  url_hash = Digest::MD5.hexdigest(url)
  cached_file = "#{CACHE_DIR}/#{url_hash}"
  if File.exist? cached_file
    puts "cache-hit: read from '#{url_hash}'"
    FileUtils.cp cached_file, outfile
  else
    download_no_cache(url, outfile)
    puts "caching as '#{url_hash}'"
    FileUtils.cp outfile, cached_file
  end
end

def download_no_cache(url, outfile, limit=5)

  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  puts "download '#{url}'"
  uri = URI.parse url
  if ENV['HTTP_PROXY']
    proxy_host, proxy_port = ENV['HTTP_PROXY'].sub(/https?:\/\//, '').split ':'
    puts "using proxy #{proxy_host}:#{proxy_port}"
    http = Net::HTTP::Proxy(proxy_host, proxy_port.to_i).new uri.host, uri.port
  else
    http = Net::HTTP.new uri.host, uri.port
  end

  if uri.port == 443
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
  end 

  http.start do |agent|
    agent.request_get(uri.path + (uri.query ? "?#{uri.query}" : '')) do |response|
      # handle 301/302 redirects
      redirect_url = response['location']
      if(redirect_url)
        puts "redirecting to #{redirect_url}"
        download_no_cache(redirect_url, outfile, limit - 1)
      else
        File.open(outfile, 'wb') do |f|
          response.read_body do |segment|
            f.write(segment)
          end
        end
      end
    end
  end
end

def unpack(archive, target_dir, includes = [])
  puts "extracting '#{archive}' to '#{target_dir}'" 
  case File.extname(archive)
  when '.zip', '.7z', '.exe'
    system("\"#{ZIP_EXE}\" x -o\"#{target_dir}\" -y \"#{archive}\" -r #{includes.join(' ')} 1> NUL")
  when '.msi'
    system("start /wait msiexec /a \"#{archive.gsub('/', '\\')}\" /qb TARGETDIR=\"#{target_dir.gsub('/', '\\')}\"")
  else 
    raise "don't know how to unpack '#{archive}'"
  end
end

def pack(target_dir, archive)
  puts "packing '#{target_dir}' into '#{archive}'"
  system("cd #{target_dir} && \"#{ZIP_EXE}\" a -t7z -y \"#{archive}\" \".\" 1> NUL && cd ..")
end

def release?
  !VERSION.end_with?('-SNAPSHOT')
end

def major_version
  VERSION.gsub(/^(\d+\.\d+).*$/, '\1')
end
