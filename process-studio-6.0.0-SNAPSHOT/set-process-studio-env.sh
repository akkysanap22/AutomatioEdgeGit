#!/bin/sh
# -----------------------------------------------------------------------------
# Finds a suitable Java
#
# Looks in well-known locations to find a suitable Java then sets two 
# environment variables for use in other script files. The two environment
# variables are:
# 
# * _PROCESS_STUDIO_JAVA_HOME - absolute path to Java home
# * _PROCESS_STUDIO_JAVA - absolute path to Java launcher (e.g. java)
# 
# The order of the search is as follows:
#
# 1. argument #1 - path to Java home
# 2. environment variable PROCESS_STUDIO_JAVA_HOME - path to Java home
# 3. jre folder at current folder level
# 4. java folder at current folder level
# 5. jre folder one level up
# 6 java folder one level up
# 7. jre folder two levels up
# 8. java folder two levels up
# 9. environment variable JAVA_HOME - path to Java home
# 10. environment variable JRE_HOME - path to Java home
# 
# If a suitable Java is found at one of these locations, then 
# _PROCESS_STUDIO_JAVA_HOME is set to that location and _PROCESS_STUDIO_JAVA is set to the 
# absolute path of the Java launcher at that location. If none of these 
# locations are suitable, then _PROCESS_STUDIO_JAVA_HOME is set to empty string and 
# _PROCESS_STUDIO_JAVA is set to java.
# 
# Finally, there is one final optional environment variable: PROCESS_STUDIO_JAVA.
# If set, this value is used in the construction of _PROCESS_STUDIO_JAVA. If not 
# set, then the value java is used. 
#
# START PROCESS_STUDIO LICENSE
# To search for the processStudio license, this script will look into the current
# for .installedLicenses.xml, one folder up and two folder up. If file is
# found in any of these location PROCESS_STUDIO_INSTALLED_LICENSE_PATH is set to that
# path including the file name
# If the processStudio license is found, it will be added as a java property flag to OPT
# END PROCESS_STUDIO LICENSE

setProcessStudioEnv() {
  DIR_REL=`dirname $0`
  cd $DIR_REL
  DIR=`pwd`
  cd -
  
  if [ -n "$PROCESS_STUDIO_JAVA" ]; then
    __LAUNCHER="$PROCESS_STUDIO_JAVA"
  else
    __LAUNCHER="java"
  fi
  if [ -n "$1" ] && [ -d "$1" ] && [ -x "$1"/bin/$__LAUNCHER ]; then
    echo "DEBUG: Using value ($1) from calling script"
    _PROCESS_STUDIO_JAVA_HOME="$1"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -n "$PROCESS_STUDIO_JAVA_HOME" ]; then
    echo "DEBUG: Using PROCESS_STUDIO_JAVA_HOME"
    _PROCESS_STUDIO_JAVA_HOME="$PROCESS_STUDIO_JAVA_HOME"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/jre/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JRE at the current folder
    _PROCESS_STUDIO_JAVA_HOME="$DIR/jre"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/java/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JAVA at the current folder
    _PROCESS_STUDIO_JAVA_HOME="$DIR/java"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/../jre/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JRE one folder up
    _PROCESS_STUDIO_JAVA_HOME="$DIR/../jre"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/../java/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JAVA one folder up
    _PROCESS_STUDIO_JAVA_HOME="$DIR/../java"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/../../jre/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JRE two folders up
    _PROCESS_STUDIO_JAVA_HOME="$DIR/../../jre"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -x "$DIR/../../java/bin/$__LAUNCHER" ]; then
    echo DEBUG: Found JAVA two folders up
    _PROCESS_STUDIO_JAVA_HOME="$DIR/../../java"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -n "$JAVA_HOME" ]; then
    echo "DEBUG: Using JAVA_HOME"
    _PROCESS_STUDIO_JAVA_HOME="$JAVA_HOME"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  elif [ -n "$JRE_HOME" ]; then
    echo "DEBUG: Using JRE_HOME"
    _PROCESS_STUDIO_JAVA_HOME="$JRE_HOME"
    _PROCESS_STUDIO_JAVA="$_PROCESS_STUDIO_JAVA_HOME"/bin/$__LAUNCHER
  else
    echo "WARNING: Using java from path"
    _PROCESS_STUDIO_JAVA_HOME=
    _PROCESS_STUDIO_JAVA=$__LAUNCHER
  fi

  echo "DEBUG: _PROCESS_STUDIO_JAVA_HOME=$_PROCESS_STUDIO_JAVA_HOME"
  echo "DEBUG: _PROCESS_STUDIO_JAVA=$_PROCESS_STUDIO_JAVA"

}
