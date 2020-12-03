rem ---------------------------------------------------------------------------
rem Finds a suitable Java
rem
rem Looks in well-known locations to find a suitable Java then sets two 
rem environment variables for use in other bat files. The two environment
rem variables are:
rem 
rem * _PROCESS_STUDIO_JAVA_HOME - absolute path to Java home
rem * _PROCESS_STUDIO_JAVA - absolute path to Java launcher (e.g. java.exe)
rem 
rem The order of the search is as follows:
rem 
rem 1. argument #1 - path to Java home
rem 2. environment variable PROCESS_STUDIO_JAVA_HOME - path to Java home
rem 3. jre folder at current folder level
rem 4. java folder at current folder level
rem 5. jre folder one level up
rem 6. java folder one level up
rem 7. jre folder two levels up
rem 8. java folder two levels up
rem 9. environment variable JAVA_HOME - path to Java home
rem 10. environment variable JRE_HOME - path to Java home
rem 
rem If a suitable Java is found at one of these locations, then 
rem _PROCESS_STUDIO_JAVA_HOME is set to that location and _PROCESS_STUDIO_JAVA is set to the 
rem absolute path of the Java launcher at that location. If none of these 
rem locations are suitable, then _PROCESS_STUDIO_JAVA_HOME is set to empty string and 
rem _PROCESS_STUDIO_JAVA is set to java.exe.
rem 
rem Finally, there is one final optional environment variable: PROCESS_STUDIO_JAVA.
rem If set, this value is used in the construction of _PROCESS_STUDIO_JAVA. If not 
rem set, then the value java.exe is used.
rem
REM START PROCESS_STUDIO LICENSE
rem To search for the processStudio license, this script will look into the current
rem for .installedLicenses.xml, one folder up and two folder up. If file is
rem found in any of these location PROCESS_STUDIO_INSTALLED_LICENSE_PATH is set to that
rem path including the file name
rem If the processStudio license is found, it will be added as a java property flag to OPT
REM END PROCESS_STUDIO LICENSE
rem ---------------------------------------------------------------------------

if not "%PROCESS_STUDIO_JAVA%" == "" goto gotProcessStudioJava
set __LAUNCHER=java.exe
goto checkProcessStudioJavaHome

:gotProcessStudioJava
set __LAUNCHER=%PROCESS_STUDIO_JAVA%
goto checkProcessStudioJavaHome

:checkProcessStudioJavaHome
if exist "%~1\bin\%__LAUNCHER%" goto gotValueFromCaller
if not "%PROCESS_STUDIO_JAVA_HOME%" == "" goto gotProcessStudioJavaHome
if exist "%~dp0jre\bin\%__LAUNCHER%" goto gotJreCurrentFolder
if exist "%~dp0java\bin\%__LAUNCHER%" goto gotJavaCurrentFolder
if exist "%~dp0..\jre\bin\%__LAUNCHER%" goto gotJreOneFolderUp
if exist "%~dp0..\java\bin\%__LAUNCHER%" goto gotJavaOneFolderUp
if exist "%~dp0..\..\jre\bin\%__LAUNCHER%" goto gotJreTwoFolderUp
if exist "%~dp0..\..\java\bin\%__LAUNCHER%" goto gotJavaTwoFolderUp
if exist "%AE_JRE_HOME%\bin\%__LAUNCHER%" goto gotAEJreHome
if not "%JAVA_HOME%" == "" goto gotJdkHome
if not "%JRE_HOME%" == "" goto gotJreHome
goto gotPath

:gotProcessStudioJavaHome
echo DEBUG: Using PROCESS_STUDIO_JAVA_HOME
set _PROCESS_STUDIO_JAVA_HOME=%PROCESS_STUDIO_JAVA_HOME%
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJreCurrentFolder
echo DEBUG: Found JRE at the current folder
set _PROCESS_STUDIO_JAVA_HOME=%~dp0jre
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJavaCurrentFolder
echo DEBUG: Found JAVA at the current folder
set _PROCESS_STUDIO_JAVA_HOME=%~dp0java
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJreOneFolderUp
echo DEBUG: Found JRE one folder up
set _PROCESS_STUDIO_JAVA_HOME=%~dp0..\jre
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJavaOneFolderUp
echo DEBUG: Found JAVA one folder up
set _PROCESS_STUDIO_JAVA_HOME=%~dp0..\java
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJreTwoFolderUp
echo DEBUG: Found JRE two folder up
set _PROCESS_STUDIO_JAVA_HOME=%~dp0..\..\jre
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJavaTwoFolderUp
echo DEBUG: Found JAVA two folder up
set _PROCESS_STUDIO_JAVA_HOME=%~dp0..\..\java
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

rem --------- Changes done for AE Installer : START -----------------
:gotAEJreHome
echo DEBUG: Found AE_JRE_HOME
echo Setting _PROCESS_STUDIO_JAVA_HOME to "%AE_JRE_HOME%"
set _PROCESS_STUDIO_JAVA_HOME=%AE_JRE_HOME%
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd
rem --------- Changes done for AE Installer : END   -----------------

:gotJdkHome
echo DEBUG: Using JAVA_HOME
set _PROCESS_STUDIO_JAVA_HOME=%JAVA_HOME%
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotJreHome
echo DEBUG: Using JRE_HOME
set _PROCESS_STUDIO_JAVA_HOME=%JRE_HOME%
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotValueFromCaller
echo DEBUG: Using value (%~1) from calling script
set _PROCESS_STUDIO_JAVA_HOME=%~1
set _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA_HOME%\bin\%__LAUNCHER%
goto javaEnd

:gotPath
echo WARNING: Using java from path
set _PROCESS_STUDIO_JAVA_HOME=
set _PROCESS_STUDIO_JAVA=%__LAUNCHER%

goto javaEnd

:javaEnd

echo DEBUG: _PROCESS_STUDIO_JAVA_HOME=%_PROCESS_STUDIO_JAVA_HOME%
echo DEBUG: _PROCESS_STUDIO_JAVA=%_PROCESS_STUDIO_JAVA%
REM END PROCESS_STUDIO LICENSE
