
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
V0 = $(V:0=)
Q1 = $(V:1=)
Q = $(Q1:0=@)
ECHO1 = $(V:1=@ :)
ECHO = $(ECHO1:0=@ echo)
NULLCMD = :

#### Start of system configuration section. ####
top_srcdir = $(topdir)/.
srcdir = $(top_srcdir)/ext/-test-/gvl/call_without_gvl
topdir = ../../../..
hdrdir = $(top_srcdir)/include
arch_hdrdir = $(extout)/include/$(arch)
PATH_SEPARATOR = :
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
RUBYLIB =
RUBYOPT = -
prefix = $(DESTDIR)/usr/local
rubysitearchprefix = $(rubylibprefix)/$(sitearch)
rubyarchprefix = $(rubylibprefix)/$(arch)
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorarchhdrdir = $(vendorhdrdir)/$(sitearch)
sitearchhdrdir = $(sitehdrdir)/$(sitearch)
rubyarchhdrdir = $(rubyhdrdir)/$(arch)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_VERSION_NAME)
vendorarchdir = $(vendorlibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitearchdir = $(sitelibdir)/$(sitearch)
sitelibdir = $(sitedir)/$(ruby_version)
sitedir = $(rubylibprefix)/site_ruby
rubyarchdir = $(rubylibdir)/$(arch)
rubylibdir = $(rubylibprefix)/$(ruby_version)
sitearchincludedir = $(includedir)/$(sitearch)
archincludedir = $(includedir)/$(arch)
sitearchlibdir = $(libdir)/$(sitearch)
archlibdir = $(libdir)/$(arch)
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
runstatedir = $(localstatedir)/run
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(prefix)/etc
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
archdir = $(rubyarchdir)


CC_WRAPPER = 
CC = gcc
CXX = g++
LIBRUBY = $(LIBRUBY_A)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -Wl,-rpath,$(libdir) -L$(libdir) 
LIBRUBYARG_STATIC = -Wl,-rpath,$(libdir) -L$(libdir) -l$(RUBY_SO_NAME)-static $(MAINLIBS)
empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)
CSRCFLAG = $(empty)

RUBY_EXTCONF_H = extconf.h
cflags   = $(optflags) $(debugflags) $(warnflags)
cxxflags = 
optflags = -O3 -fno-fast-math
debugflags = -ggdb3
warnflags = -Wall -Wextra -Wdeprecated-declarations -Wdiv-by-zero -Wduplicated-cond -Wimplicit-function-declaration -Wimplicit-int -Wmisleading-indentation -Wpointer-arith -Wwrite-strings -Wold-style-definition -Wimplicit-fallthrough=0 -Wmissing-noreturn -Wno-cast-function-type -Wno-constant-logical-operand -Wno-long-long -Wno-missing-field-initializers -Wno-overlength-strings -Wno-packed-bitfield-compat -Wno-parentheses-equality -Wno-self-assign -Wno-tautological-compare -Wno-unused-parameter -Wno-unused-value -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wunused-variable -Wundef
cppflags = 
CCDLFLAGS = -fPIC
CFLAGS   = $(CCDLFLAGS) $(cflags) $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS = -DRUBY_EXTCONF_H=\"$(RUBY_EXTCONF_H)\"  $(DEFS) $(cppflags)
CXXFLAGS = $(CCDLFLAGS)  $(ARCH_FLAG)
ldflags  = -L. -fstack-protector-strong -rdynamic -Wl,-export-dynamic
dldflags = -Wl,--compress-debug-sections=zlib 
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
AR = gcc-ar
EXEEXT = 

RUBY_INSTALL_NAME = $(RUBY_BASE_NAME)
RUBY_SO_NAME = ruby
RUBYW_INSTALL_NAME = 
RUBY_VERSION_NAME = $(RUBY_BASE_NAME)-$(ruby_version)
RUBYW_BASE_NAME = rubyw
RUBY_BASE_NAME = ruby

arch = x86_64-linux
sitearch = $(arch)
ruby_version = 3.2.0
ruby = $(topdir)/miniruby -I'$(topdir)' -I'$(top_srcdir)/lib' -I'$(extout)/$(arch)' -I'$(extout)/common'
RUBY = $(ruby)
BUILTRUBY = $(topdir)/miniruby
ruby_headers = $(hdrdir)/ruby.h $(hdrdir)/ruby/backward.h $(hdrdir)/ruby/ruby.h $(hdrdir)/ruby/defines.h $(hdrdir)/ruby/missing.h $(hdrdir)/ruby/intern.h $(hdrdir)/ruby/st.h $(hdrdir)/ruby/subst.h $(arch_hdrdir)/ruby/config.h $(RUBY_EXTCONF_H)

RM = rm -f
RM_RF = rm -fr
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /usr/bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp
TOUCH = exit >

#### End of system configuration section. ####

preload = 
EXTSO = 
libpath = . $(topdir)
LIBPATH =  -L. -L$(topdir)
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = $(topdir)/.ext
extout_prefix = $(extout)$(target_prefix)/
target_prefix = /-test-/gvl
LOCAL_LIBS = 
LIBS =   -lm -lpthread  -lc
ORIG_SRCS = call_without_gvl.c
SRCS = $(ORIG_SRCS) 
OBJS = call_without_gvl.o
HDRS = 
LOCAL_HDRS = 
TARGET = call_without_gvl
TARGET_NAME = call_without_gvl
TARGET_ENTRY = Init_$(TARGET_NAME)
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

TIMESTAMP_DIR = $(extout)/.timestamp
BINDIR        = $(extout)/bin
RUBYCOMMONDIR = $(extout)/common
RUBYLIBDIR    = $(RUBYCOMMONDIR)$(target_prefix)
RUBYARCHDIR   = $(extout)/$(arch)$(target_prefix)
HDRDIR        = $(extout)/include/ruby$(target_prefix)
ARCHHDRDIR    = $(extout)/include/$(arch)/ruby$(target_prefix)
TARGET_SO_DIR = $(RUBYARCHDIR)/
TARGET_SO     = $(TARGET_SO_DIR)$(DLLIB)
CLEANLIBS     = $(TARGET_SO) false
CLEANOBJS     = $(OBJS) $(OBJS:.o=.bc) $(OBJS:.o=.i) $(OBJS:.o=.s) *.bak
TARGET_SO_DIR_TIMESTAMP = $(TIMESTAMP_DIR)/$(arch)/.-test-.-.gvl.time

all:    install
static: all
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

clean-static::
clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-static clean-rb-default clean-rb
		-$(Q)$(RM_RF) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES) .*.time

distclean-rb-default::
distclean-rb::
distclean-so::
distclean-static::
distclean: clean distclean-so distclean-static distclean-rb-default distclean-rb
		-$(Q)$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log exts.mk
		-$(Q)$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		-$(Q)$(RMDIRS) $(DISTCLEANDIRS) 2> /dev/null || true

realclean: distclean
install: install-so install-rb

install-so: $(TARGET_SO)
clean-so::
	-$(Q)$(RM) $(TARGET_SO) $(TARGET_SO_DIR_TIMESTAMP)
	-$(Q)$(RMDIRS) $(TARGET_SO_DIR) 2> /dev/null || true
clean-static::
	-$(Q)$(RM) $(STATIC_LIB)
install-rb: pre-install-rb do-install-rb install-rb-default
install-rb-default: pre-install-rb-default do-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
do-install-rb:
do-install-rb-default:
pre-install-rb-default:
	@$(NULLCMD)
$(TARGET_SO_DIR_TIMESTAMP):
	$(Q) $(MAKEDIRS) $(@D) $(TARGET_SO_DIR)
	$(Q) $(TOUCH) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .o .S

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cc.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.mm.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cxx.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cpp.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.c.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.m.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

$(TARGET_SO): $(OBJS) Makefile $(TARGET_SO_DIR_TIMESTAMP)
	$(ECHO) linking shared-object -test-/gvl/$(DLLIB)
	-$(Q)$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



###
$(OBJS): $(RUBY_EXTCONF_H)

# AUTOGENERATED DEPENDENCIES START
call_without_gvl.o: $(RUBY_EXTCONF_H)
call_without_gvl.o: $(arch_hdrdir)/ruby/config.h
call_without_gvl.o: $(hdrdir)/ruby/assert.h
call_without_gvl.o: $(hdrdir)/ruby/backward.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/assume.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/attributes.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/bool.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/inttypes.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/limits.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/long_long.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/stdalign.h
call_without_gvl.o: $(hdrdir)/ruby/backward/2/stdarg.h
call_without_gvl.o: $(hdrdir)/ruby/defines.h
call_without_gvl.o: $(hdrdir)/ruby/intern.h
call_without_gvl.o: $(hdrdir)/ruby/internal/abi.h
call_without_gvl.o: $(hdrdir)/ruby/internal/anyargs.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/char.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/double.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/fixnum.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/gid_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/int.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/intptr_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/long.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/long_long.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/mode_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/off_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/pid_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/short.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/size_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/st_data_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/arithmetic/uid_t.h
call_without_gvl.o: $(hdrdir)/ruby/internal/assume.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/alloc_size.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/artificial.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/cold.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/const.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/constexpr.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/deprecated.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/diagnose_if.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/enum_extensibility.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/error.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/flag_enum.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/forceinline.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/format.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/maybe_unused.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/noalias.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/nodiscard.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/noexcept.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/noinline.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/nonnull.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/noreturn.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/pure.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/restrict.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/returns_nonnull.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/warning.h
call_without_gvl.o: $(hdrdir)/ruby/internal/attr/weakref.h
call_without_gvl.o: $(hdrdir)/ruby/internal/cast.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/apple.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/clang.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/gcc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/intel.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/msvc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_is/sunpro.h
call_without_gvl.o: $(hdrdir)/ruby/internal/compiler_since.h
call_without_gvl.o: $(hdrdir)/ruby/internal/config.h
call_without_gvl.o: $(hdrdir)/ruby/internal/constant_p.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rarray.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rbasic.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rbignum.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rclass.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rdata.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rfile.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rhash.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/robject.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rregexp.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rstring.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rstruct.h
call_without_gvl.o: $(hdrdir)/ruby/internal/core/rtypeddata.h
call_without_gvl.o: $(hdrdir)/ruby/internal/ctype.h
call_without_gvl.o: $(hdrdir)/ruby/internal/dllexport.h
call_without_gvl.o: $(hdrdir)/ruby/internal/dosish.h
call_without_gvl.o: $(hdrdir)/ruby/internal/error.h
call_without_gvl.o: $(hdrdir)/ruby/internal/eval.h
call_without_gvl.o: $(hdrdir)/ruby/internal/event.h
call_without_gvl.o: $(hdrdir)/ruby/internal/fl_type.h
call_without_gvl.o: $(hdrdir)/ruby/internal/gc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/glob.h
call_without_gvl.o: $(hdrdir)/ruby/internal/globals.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/attribute.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/builtin.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/c_attribute.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/cpp_attribute.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/declspec_attribute.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/extension.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/feature.h
call_without_gvl.o: $(hdrdir)/ruby/internal/has/warning.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/array.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/bignum.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/class.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/compar.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/complex.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/cont.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/dir.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/enum.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/enumerator.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/error.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/eval.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/file.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/gc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/hash.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/io.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/load.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/marshal.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/numeric.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/object.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/parse.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/proc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/process.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/random.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/range.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/rational.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/re.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/ruby.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/select.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/select/largesize.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/signal.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/sprintf.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/string.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/struct.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/thread.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/time.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/variable.h
call_without_gvl.o: $(hdrdir)/ruby/internal/intern/vm.h
call_without_gvl.o: $(hdrdir)/ruby/internal/interpreter.h
call_without_gvl.o: $(hdrdir)/ruby/internal/iterator.h
call_without_gvl.o: $(hdrdir)/ruby/internal/memory.h
call_without_gvl.o: $(hdrdir)/ruby/internal/method.h
call_without_gvl.o: $(hdrdir)/ruby/internal/module.h
call_without_gvl.o: $(hdrdir)/ruby/internal/newobj.h
call_without_gvl.o: $(hdrdir)/ruby/internal/rgengc.h
call_without_gvl.o: $(hdrdir)/ruby/internal/scan_args.h
call_without_gvl.o: $(hdrdir)/ruby/internal/special_consts.h
call_without_gvl.o: $(hdrdir)/ruby/internal/static_assert.h
call_without_gvl.o: $(hdrdir)/ruby/internal/stdalign.h
call_without_gvl.o: $(hdrdir)/ruby/internal/stdbool.h
call_without_gvl.o: $(hdrdir)/ruby/internal/symbol.h
call_without_gvl.o: $(hdrdir)/ruby/internal/value.h
call_without_gvl.o: $(hdrdir)/ruby/internal/value_type.h
call_without_gvl.o: $(hdrdir)/ruby/internal/variable.h
call_without_gvl.o: $(hdrdir)/ruby/internal/warning_push.h
call_without_gvl.o: $(hdrdir)/ruby/internal/xmalloc.h
call_without_gvl.o: $(hdrdir)/ruby/missing.h
call_without_gvl.o: $(hdrdir)/ruby/ruby.h
call_without_gvl.o: $(hdrdir)/ruby/st.h
call_without_gvl.o: $(hdrdir)/ruby/subst.h
call_without_gvl.o: $(hdrdir)/ruby/thread.h
call_without_gvl.o: call_without_gvl.c
# AUTOGENERATED DEPENDENCIES END
