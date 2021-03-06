
require_relative '../helpers'

describe "Ruby DevPack" do

  include Helpers

  describe "tools" do
    it "installs Ruby 2.2.1" do
      run_cmd("ruby -v").should match('2.2.1')
    end
    it "installs RubyGems 2.4.5" do
      run_cmd("gem -v").should match("2.4.5")
    end
    it "installs Git 1.9.5" do
      run_cmd("git --version").should match('git version 1.9.5')
    end
    it "installs kdiff3" do
      marker_file = "#{BUILD_DIR}/merged.md"
      begin
        run_cmd("kdiff3 README.md README.md --auto -cs LineEndStyle=0 -o #{marker_file}")
        File.exist?(marker_file).should be true
      ensure
        File.delete(marker_file) if File.exist?(marker_file)
      end
    end
    it "installs clink 0.4.4" do
      run_cmd("#{BUILD_DIR}/tools/clink/clink.bat version").should match('Clink v0.4.4')
    end
  end

  describe "environment" do
    it "sets HOME to X:/home" do
      env_match "HOME=#{BUILD_DIR}/home"
    end
    it "sets TERM=rxvt" do
      env_match "TERM=rxvt"
    end
    it "sets ANSICON=true" do
      env_match "ANSICON=true"
    end
    it "sets RI to use plain format" do
      env_match "RI=--format bs"
    end
    it "sets SSL_CERT_FILE to X:/home/cacert.pem" do
      env_match "SSL_CERT_FILE=#{BUILD_DIR}/home/cacert.pem"
    end
  end

  describe "aliases" do
    it "aliases `bundle exec` to `be`" do
      run_cmd("doskey /macros").should match('be=bundle exec $*')
    end
    it "aliases `sublime_text` to `vi`" do
      run_cmd("doskey /macros").should match('vi=sublime_text $*')
    end
  end

  describe "ruby installations" do

    describe "system ruby" do
      it "provides the default `ruby` command" do
        run_cmd("which ruby").should match(convert_slashes("#{SYSTEM_RUBY}/bin/ruby.EXE"))
      end
      it "provides the default `gem` command" do
        run_cmd("which gem").should match(convert_slashes("#{SYSTEM_RUBY}/bin/gem"))
      end
      it "uses the system ruby gemdir" do
        run_cmd("#{SYSTEM_RUBY}/bin/gem environment gemdir").should match("#{SYSTEM_RUBY}/lib/ruby/gems/2.2.0")
      end
      it "has 'bundler (1.8.4)' gem installed" do
        gem_installed "bundler", "1.8.4"
      end
    end
  end
end