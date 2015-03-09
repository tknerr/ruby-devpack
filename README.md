
# Ruby DevPack

A [DevPack](http://blog.tknerr.de/blog/2014/10/09/devpack-philosophy-aka-works-on-your-machine/) with all you need for developing with Ruby on Windows, shrink-wrapped in a portable package. 

No installation, just [extract and get going](#usage)!

![Ruby DevPack Screenshot](https://raw.github.com/tknerr/ruby-devpack/master/doc/ruby_devpack_screenshot.png)


## What's inside?

### Main Tools

The main tools for hacking Ruby:

* [Ruby](http://rubyinstaller.org/downloads/) 2.2.1
* [DevKit](http://rubyinstaller.org/add-ons/devkit/) 4.7.2

### Supporting Tools

Useful additions for a better cooking experience:

* [ConEmu](https://code.google.com/p/conemu-maximus5/) - a better Windows console with colours, tabs, etc...
* [SublimeText2](http://www.sublimetext.com/) - a better editor (trial version)
* [PortableGit](https://code.google.com/p/msysgit/) - git client for Windows (preconfigured with [kdiff3](http://kdiff3.sourceforge.net/) as diff/merge tool)
* [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) - the SSH client for Windows
* [clink](http://mridgers.github.io/clink/) - command completion and Bash-like line editing for Windows

### Environmental Changes

The following changes are applied to your environment by running `X:\set-env.bat`:

* Constraining as much as possible to the `X:\` drive:
 * `%HOME%` points to `X:\home`
 * `%PATH%` is preprended with the bin dirs of the tools in `X:\tools\`
* Fixing annoyances:
 * `set ANSICON=true` to get coloured console output
 * `set RI=--format bs` to restore plain (i.e. non-ansi colored) output for ri 
 * `set SSL_CERT_FILE=X:\home\cacert.pem` pointing to recent CA certs avoiding Ruby SSL errors

### Aliases

Registered doskey aliases:

* run `be <command>` for `bundle exec <command>`
* run `vi <file_or_dir>` for `sublime_text <file_or_dir>` 

## Installation and Usage

Using the Ruby DevPack is fairly simple. There is nothing to install, just unpack and go:

1. Grab the latest `ruby-devpack-<version>.7z` package from the [releases page](https://github.com/tknerr/ruby-devpack/releases) and unpack it
1. Mount the devpack to the `X:\` drive by double-clicking the `mount-drive.bat` file
1. Click `X:\Launch ConEmu.lnk` to open a command prompt (also runs `X:\set-env.bat` to set up the environment)
1. Start hacking!

## Building from Source (Development)

As a prerequisite for building the Ruby DevPack you need a Ruby environment (yes chicken-egg ;-)) and 7zip installed in `C:\Program Files\7-Zip\7z.exe`.

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


### Changing the Mount Drive Letter

By default the Ruby DevPack will be mounted to the `X:\` drive. If you need to change it you only have to update the references in these two files:

* `mount-drive.cmd`
* `unmount-drive.cmd`

## Usage

1. unzip the `target/ruby-devpack-<version>.7z` somewhere
2. mount the devpack to the `X:\` drive by double-clicking the `mount-w-drive.bat` file
3. click `X:\Launch ConEmu.lnk` to open a command prompt
4. in the command prompt run `X:\set-env.bat` to set up the environment
5. start hacking!

## Acknowledgements & Licensing

This Ruby DevPack bundles lots of awesome Open Source software. The copyright owners of this software are mentioned here. For a full-text version of the licenses mentioned above please have a look in the `tools` directory where the respective software is installed.

* ConEmu - Copyright (c) 2006-2008 Zoin <zoinen@gmail.com>, 2009-2013 Maximus5 <ConEmu.Maximus5@gmail.com> (BSD 3-Clause license)
* clink - Copyright (c) 2012-2014 Martin Ridgers (MIT license), 1994–2012 Lua.org, PUC-Rio (GPLv3)
* PortableGit - by msysGit team (GPLv2 license)
* RubyInstaller - Copyright (c), 2007-2014 RubyInstaller Team (BSD 3-Clause license)
* DevKit - Copyright (c), 2007-2014 RubyInstaller Team (BSD 3-Clause license)
* kdiff3 - Copyright (c) 2002-2012 Joachim Eibl (GPLv2 license)
* putty - Copyright (c) 1997-2014 Simon Tatham (MIT license)

It also includes an evaluation copy of the awesome [Sublime Text 2](http://www.sublimetext.com/) editor. Please use it for evaluation purposes only (no commercial usage) or [buy a license](http://www.sublimetext.com/buy) if you like it! 

The Ruby DevPack itself is published under the MIT license. It is not "derivative work" but rather ["mere aggregation"](https://www.gnu.org/licenses/gpl-faq.html#MereAggregation) of other software and thus does not need to be licensed under GPL itself.
