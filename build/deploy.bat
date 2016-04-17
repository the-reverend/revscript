@echo off

set cm_script_drive=%~d0
set cm_script_path=%~dp0
set cm_script_name=%~n0
set cm_script_header=%cm_script_name% (version 0.0.1^)

set cm_nextarg=
set cm_srcpath=..\src\
set cm_dstpath=..\..\revhelper\script\
set cm_cab=__revhelper
set cm_pause=-pause
set cm_verbose=-verbose
set cm_lstfile=%cm_script_path%deploy.txt
set cm_cabfile=%cm_dstpath%__revhelper.cab

:command_line
if .%1==. goto :command_line_end

if "%cm_nextarg%"=="src" goto :set_srcpath
if "%cm_nextarg%"=="dst" goto :set_dstpath
if "%cm_nextarg%"=="lst" goto :set_lstfile
if "%cm_nextarg%"=="cab" goto :set_cabfile

if "%1"=="-s"       set cm_nextarg=src
if "%1"=="-d"       set cm_nextarg=dst
if "%1"=="-l"       set cm_nextarg=lst
if "%1"=="-z"       set cm_nextarg=cab

if "%1"=="-verbose" set cm_verbose=%1
if "%1"=="+verbose" set cm_verbose=%1
if "%1"=="-pause"   set cm_pause=%1
if "%1"=="+pause"   set cm_pause=%1

if "%1"=="-help"    goto :show_help
if "%1"=="-h"       goto :show_help
if "%1"=="-?"       goto :show_help

shift
goto :command_line

:set_srcpath
set cm_srcpath=%~dp1
set cm_nextarg=
shift
goto :command_line

:set_dstpath
set cm_dstpath=%~dp1
set cm_nextarg=
shift
goto :command_line

:set_lstfile
set cm_lstfile=%~dpnx1
set cm_nextarg=
shift
goto :command_line

:set_cabfile
set cm_cabfile=%~dpnx1
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
echo = cm_srcpath=%cm_srcpath%
echo = cm_dstpath=%cm_dstpath%
echo = cm_pause=%cm_pause%
echo = cm_verbose=%cm_verbose%
echo = cm_lstfile=%cm_lstfile%
echo = cm_cabfile=%cm_cabfile%
)
goto :end_fail

:command_line_end
if defined cm_nextarg goto :show_help
if not defined cm_srcpath goto :show_help
if not exist "%cm_lstfile%" goto :error_no_list

:copy_all_files
if "%cm_verbose%"=="+verbose" echo = %cm_script_header%
for /f "usebackq delims=" %%a in ("%cm_lstfile%") do call :copy_one_file "%%a"
rem del /F "%cm_cabfile%"
rem ..\_bin\cabarc n "%cm_cabfile%" "%cm_dstpath%*.*"
goto :end_success

:copy_one_file
setlocal
set f=%1
set n=%~nx1
set r=failed
set b=
xcopy "%cm_srcpath%%f%" "%cm_dstpath%" /r /y /q 1>NUL 2>NUL
if %errorlevel%==0 set r=copied
if "%r%"=="failed" if "%cm_verbose%"=="+verbose" echo = %r% %f% %b%
if "%r%"=="copied" echo = %r% %f% %b%
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