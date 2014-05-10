
# Ruby DevPack

A DevPack with all you need for developing with Ruby on Windows, shrink-wrapped in a portable package.

## What's inside?

### Main Tools

The main tools for cooking with Chef / Vagrant:

* [Ruby](http://rubyinstaller.org/downloads/) 1.9.3
* [DevKit](http://rubyinstaller.org/add-ons/devkit/) 4.5.2

### Supporting Tools

Useful additions for a better cooking experience:

* [ConEmu](https://code.google.com/p/conemu-maximus5/) - a better windows console with colours, tabs, etc...
* [SublimeText2](http://www.sublimetext.com/) - a better editor (trial version)
* [PortableGit](https://code.google.com/p/msysgit/) - git client for windows (preconfigured with [kdiff3](http://kdiff3.sourceforge.net/) as diff/merge tool)
* [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) - the SSH client for windows

### Environmental Changes

The following changes are applied to your environment by running `W:\set-env.bat`:

* Constraining as much as possible to the `W:\` drive:
 * `%HOME%` points to `W:\home`
 * `%PATH%` is preprended with the bin dirs of the tools in `W:\tools\`
* Fixing annoyances:
 * `set ANSICON=true` to get coloured console output
 * `set SSL_CERT_FILE=W:\home\cacert.pem` pointing to recent CA certs avoiding Ruby SSL errors

### Aliases

Registered doskey aliases:

* run `be <command>` for `bundle exec <command>`
* run `vi <file_or_dir>` for `sublime_text <file_or_dir>` 

## Installation

As a prerequisite for building the Ruby DevPack you need Ruby (yes chicken-egg ;-)) and 7zip installed in `C:\Program Files\7-Zip\7z.exe`.

### Building the Ruby DevPack

To build the Ruby DevPack (make sure you don't have spaces in the path):
```
$ gem install bundler
$ bundle install
$ rake build
```

This might take a while (you can go fetch a coffee). It will download the external dependencies, install the tools and prepare everything else we need into the `target/build` directory. Finally it runs the `spec/integration` examples to ensure everything is properly installed.


### Packaging

Finally, if all the tests pass you can create a portable zip package:
```
$ rake package
```

This will and finally package everything in the `target/build` directory into `target/ruby-devpack-<version>.7z`.


## Usage

1. unzip the `target/ruby-devpack-<version>.7z` somewhere
2. mount the devpack to the `W:\` drive by double-clicking the `mount-w-drive.bat` file
3. click `W:\Launch ConEmu.lnk` to open a command prompt
4. in the command prompt run `W:\set-env.bat` to set up the environment
5. start hacking!