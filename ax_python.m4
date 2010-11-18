# ===========================================================================
#            http://www.nongnu.org/autoconf-archive/ax_python.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PYTHON
#
# DESCRIPTION
#
#   This macro does a complete Python development environment check.
#
#   It recurses through several python versions (from 2.1 to 2.6 in this
#   version), looking for an executable. When it finds an executable, it
#   looks to find the header files and library.
#
#   It sets PYTHON_BIN to the name of the python executable,
#   PYTHON_INCLUDE_DIR to the directory holding the header files, and
#   PYTHON_LIB to the name of the Python library.
#
#   This macro calls AC_SUBST on PYTHON_BIN (via AC_CHECK_PROG),
#   PYTHON_INCLUDE_DIR and PYTHON_LIB.
#
# LICENSE
#
#   Copyright (c) 2008 Michael Tindal
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation; either version 2 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

AC_DEFUN([AX_PYTHON],
[AC_MSG_CHECKING(for python build information)
AC_MSG_RESULT([])
AC_ARG_WITH([python],AS_HELP_STRING([--with-python],[specify the Python include path (where header files are)]),
[if test "x$with_python" != "xno"; then
   ax_python_header=$with_python
 fi])
for python in python2.7 python2.6 python2.5 python2.4 python2.3 python2.2 python2.1 python2 python; do
  AC_CHECK_PROGS(PYTHON_BIN, [$python])
  ax_python_bin=$PYTHON_BIN
  if test x$ax_python_bin != x; then
     AC_CHECK_LIB($ax_python_bin, main, ax_python_lib=$ax_python_bin, ax_python_lib=no)
     if test "x$ax_python_lib" != "xno" &&
        test "x$ax_python_header" != "xno" &&
        test "x$ax_python_header" != "x"; then
       break;
     fi
     include_paths=`locate $ax_python_bin/Python.h | sed -e s:/Python.h::`
     num_include_paths=`echo "$include_paths" |wc -l`
     if test $num_include_paths -eq 0; then
       AC_MSG_ERROR([could not find any Python include path for $PYTHON_BIN])
     elif test $num_include_paths -gt 1; then
       error_msg=`for path in $include_paths; do echo "  $path"; done`
       AC_MSG_ERROR([more than one possible Python include path for $PYTHON_BIN.
Please select one using --with-python=<include-path>. Possible options are:
$error_msg])
     fi
     AC_CHECK_HEADER([$ax_python_bin/Python.h],
                     [ax_python_header=$include_paths],
                     [ax_python_header=no])
     if test "x$ax_python_lib" != "xno" && test "x$ax_python_header" != "xno"; then
       break;
     fi
  fi
done
if test x$ax_python_bin = x; then
   ax_python_bin=no
fi
if test x$ax_python_header = x; then
   ax_python_header=no
fi
if test x$ax_python_lib = x; then
   ax_python_lib=no
fi

AC_MSG_RESULT([  results of the Python check:])
AC_MSG_RESULT([    Binary:      $ax_python_bin])
AC_MSG_RESULT([    Library:     $ax_python_lib])
AC_MSG_RESULT([    Include Dir: $ax_python_header])

if test x$ax_python_header != xno; then
  PYTHON_INCLUDE_DIR=$ax_python_header
  AC_SUBST(PYTHON_INCLUDE_DIR)
fi
if test x$ax_python_lib != xno; then
  PYTHON_LIB=$ax_python_lib
  AC_SUBST(PYTHON_LIB)
fi
])dnl
