
# 0.4 (unreleased)

 * add `~/.bundle/config`, which
     * enables parallelism while downloading / installing gems
     * enables up to 3 retries when downloading gems
     * sets `BUNDLE_PATH` to `~/.gem/ruby/2.2.0` where all bundle installed gems will now end up

# 0.3 (March 08, 2015)

 * made it easier to change the mount drive letter ([#1](https://github.com/tknerr/ruby-devpack/issues/1))
 * fix setting git username ([#2](https://github.com/tknerr/ruby-devpack/issues/2))
 * use Consolas as the default font for ConEmu rather than Monaco (not included in Win7)
 * update packaging to that it does not include the intermediary build directory anymore
 * add license information and acknowledgements
 * tool updates
 	* add clink for command autocompletion ([#3](https://github.com/tknerr/ruby-devpack/issues/3)), but disabled it by default
 	* update to Ruby 2.2.1
 	* update to PortableGit 1.9.5
 	* update to ConEmu 20150305
 	* update to bundler 1.8.4
 	* update to clink 0.4.4
 
# 0.2 (May 10, 2014)

 * updated tools:
   * Ruby 2.0.0p451
   * DevKit 4.7.2
   * Bundler 1.6.2

# 0.1 (May 10, 2014)

Initial version, based on [Bill's Kitchen](https://github.com/tknerr/bills-kitchen) 1.0 but with Chef and Vagrant specifics being stripped out. It currently includes:
 
 * Ruby 1.9.3
 * DevKit 4.5.2
 * ConEmu
 * SublimeText2
 * PortableGit
 * putty