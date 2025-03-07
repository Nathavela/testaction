# frozen_string_literal: true
# shareable_constant_value: literal
baseruby="/usr/bin/ruby --disable=gems"
_\
=begin
_=
ruby="${RUBY-$baseruby}"
case "$ruby" in "echo "*) $ruby; exit $?;; esac
case "$0" in /*) r=-r"$0";; *) r=-r"./$0";; esac
exec $ruby "$r" "$@"
=end
=baseruby
class Object
  remove_const :CROSS_COMPILING if defined?(CROSS_COMPILING)
  CROSS_COMPILING = RUBY_PLATFORM
  constants.grep(/^RUBY_/) {|n| remove_const n}
  RUBY_VERSION = "3.2.6"
  RUBY_RELEASE_DATE = "2024-10-30"
  RUBY_PLATFORM = "x86_64-linux"
  RUBY_PATCHLEVEL = 234
  RUBY_REVISION = "63aeb018eb1cc0f7b00f955980711fd1bd94af7f"
  RUBY_COPYRIGHT = "ruby - Copyright (C) 1993-2024 Yukihiro Matsumoto"
  RUBY_ENGINE = "ruby"
  RUBY_ENGINE_VERSION = "3.2.6"
  RUBY_DESCRIPTION = case
    when RubyVM.const_defined?(:MJIT) && RubyVM::MJIT.enabled?
      "ruby 3.2.6 (2024-10-30 revision 63aeb018eb) +MJIT [x86_64-linux]"
    when RubyVM.const_defined?(:YJIT) && RubyVM::YJIT.enabled?
      "ruby 3.2.6 (2024-10-30 revision 63aeb018eb) +YJIT [x86_64-linux]"
    else
      "ruby 3.2.6 (2024-10-30 revision 63aeb018eb) [x86_64-linux]"
    end
end
builddir = File.dirname(File.expand_path(__FILE__))
libpathenv = libpathenv = "LD_LIBRARY_PATH"
preloadenv = preloadenv = "LD_PRELOAD"
libruby_so = libruby_so = "libruby.so.3.2.6"
srcdir = "."
top_srcdir = File.realpath(srcdir, builddir)
fake = File.join(top_srcdir, "tool/fake.rb")
eval(File.binread(fake), nil, fake)
ropt = "-r#{__FILE__}"
["RUBYOPT"].each do |flag|
  opt = ENV[flag]
  opt = opt ? ([ropt] | opt.b.split(/\s+/)).join(" ") : ropt
  ENV[flag] = opt
end
