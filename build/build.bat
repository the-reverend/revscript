@echo off

set cm_script_drive=%~d0
set cm_script_path=%~dp0
set cm_script_name=%~n0
set cm_script_header=%cm_script_name% (version 0.0.1^)

set cm_nextarg=
set cm_libpath=..\src\_library\
set cm_srcfile=%cm_script_path%build.txt
set cm_pause=-pause
set cm_verbose=-verbose

:command_line
if .%1==. goto :command_line_end

if "%cm_nextarg%"=="lib" goto :set_libpath
if "%cm_nextarg%"=="src" goto :set_srcfile

if "%1"=="-l"       set cm_nextarg=lib
if "%1"=="-s"       set cm_nextarg=src

if "%1"=="-verbose" set cm_verbose=%1
if "%1"=="+verbose" set cm_verbose=%1
if "%1"=="-pause"   set cm_pause=%1
if "%1"=="+pause"   set cm_pause=%1

if "%1"=="-help"    goto :show_help
if "%1"=="-h"       goto :show_help
if "%1"=="-?"       goto :show_help

shift
goto :command_line

:set_libpath
set cm_libpath=%~dp1
set cm_nextarg=
shift
goto :command_line

:set_srcfile
set cm_srcfile=%~dpnx1
set cm_nextarg=
shift
goto :command_line

:show_help
echo = %cm_script_header%
echo = copyright (c^) 2009 by ^<rev@thereverend.org^>
echo =
echo = usage:
echo =  %cm_script_name% -help
echo =  %cm_script_name% -s srcpath [-d dstpath] [-l listfile] [+/-pause] [+/-verbose]
echo =
echo = examples:
echo =  %cm_script_name% -s ..\ -d ..\public\ +pause +verbose
echo =
if "%cm_verbose%"=="+verbose" (
echo = cm_script_drive=%cm_script_drive%
echo = cm_script_path=%cm_script_path%
echo = cm_script_name=%cm_script_name%
echo = cm_nextarg=%cm_nextarg%
echo = cm_srcfile=%cm_srcfile%
echo = cm_pause=%cm_pause%
echo = cm_verbose=%cm_verbose%
echo = cm_libpath=%cm_libpath%
)
goto :end_fail

:command_line_end
if defined cm_nextarg goto :show_help
if not defined cm_srcfile goto :show_help
if not exist "%cm_srcfile%" goto :error_no_list

:copy_all_files
if "%cm_verbose%"=="+verbose" echo = %cm_script_header%
for /f "usebackq delims=" %%a in ("%cm_srcfile%") do call :build_one_folder "%%a"
goto :end_success

:build_one_folder
setlocal
for /r %%a in (%1*.zrx) do call :build_one_file "%%a"
endlocal
goto :eof

:build_one_file
setlocal
set f=%~f1
set n=%~nx1
set r=failed
set b=
echo building %n%
..\bin\rb "%f%" "%cm_libpath%" rev 1>NUL 2>NUL
echo .
if %errorlevel%==0 set r=built
rem if "%r%"=="failed" if "%cm_verbose%"=="+verbose" echo = %r% %f% %b%
rem if "%r%"=="built" echo = %r% %f% %b%
endlocal
goto :eof

:error_no_list
echo = %cm_script_header%
echo =
echo = error:
echo = file not found %cm_lstfile%
echo =
goto :end_fail

:end_success
set cm_err=0
goto :end

:end_fail
set cm_err=0
goto :end

:end
if "%cm_pause%"=="+pause" pause
exit /b %cm_err%