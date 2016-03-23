@if /i "%1" NEQ "-verbose" @echo off
setlocal

REM #### general config
set programFilesWithMozilla=%programfiles%
if not exist "%programFilesWithMozilla%\Mozilla Firefox" set programFilesWithMozilla=%programfiles(x86)%
if not exist "%programFilesWithMozilla%\Mozilla Firefox" exit /B 1

REM #### default firefox profile
set firefoxdefaultprofile=%programFilesWithMozilla%\Mozilla Firefox\browser\defaults\Profile
if not exist "%firefoxdefaultprofile%" mkdir "%firefoxdefaultprofile%"
if not exist "%firefoxdefaultprofile%\cert8.db" copy /y "%~dp0db\empty\cert8.db" "%firefoxdefaultprofile%\" >NUL
if not exist "%firefoxdefaultprofile%\key3.db" copy /y "%~dp0db\empty\key3.db" "%firefoxdefaultprofile%\" >NUL
if not exist "%firefoxdefaultprofile%\secmod.db" copy /y "%~dp0db\empty\secmod.db" "%firefoxdefaultprofile%\" >NUL

setlocal ENABLEDELAYEDEXPANSION
set replacepath=%~dp0cacert\
FOR /R "%~dp0" %%C IN (cacert\*.pem) DO (
set certpath=%%C
set certfile=!certpath:%replacepath%=!
set certfile=!certfile:.pem=!
set certfile=!certfile:.cacert=!
set certfile=AddedByUser !certfile!
"%~dp0bin\certutil.exe" -A -n "!certfile!" -i "%%C" -t "cTC,cTC,cTC", -d "%firefoxdefaultprofile%"
)
setlocal DISABLEDELAYEDEXPANSION


REM ####user profiles
setlocal ENABLEDELAYEDEXPANSION
set replacepath=%~dp0cacert\
FOR /D %%U IN ("%systemdrive%\Users\*") DO (
FOR /D %%P IN ("%%U\AppData\Roaming\Mozilla\Firefox\Profiles\*") DO if not exist "%%P\cert8.db" copy /y "%~dp0db\empty\cert8.db" "%%P\" >NUL
FOR /D %%P IN ("%%U\AppData\Roaming\Mozilla\Firefox\Profiles\*") DO if not exist "%%P\key3.db" copy /y "%~dp0db\empty\key3.db" "%%P\" >NUL
FOR /D %%P IN ("%%U\AppData\Roaming\Mozilla\Firefox\Profiles\*") DO if not exist "%%P\secmod.db" copy /y "%~dp0db\empty\secmod.db" "%%P\" >NUL
FOR /R "%~dp0" %%C IN (cacert\*.pem) DO (
set certpath=%%C
set certfile=!certpath:%replacepath%=!
set certfile=!certfile:.pem=!
set certfile=!certfile:.cacert=!
set certfile=AddedByUser !certfile!
FOR /D %%P IN ("%%U\AppData\Roaming\Mozilla\Firefox\Profiles\*") DO (
 "%~dp0bin\certutil.exe" -A -n "!certfile!" -i "%%C" -t "cTC,cTC,cTC", -d "%%P"
)
))
setlocal DISABLEDELAYEDEXPANSION

REM ####Current user
setlocal ENABLEDELAYEDEXPANSION
set replacepath=%~dp0cacert\
FOR /R "%~dp0" %%C IN (cacert\*.pem) DO (
set certpath=%%C
set certfile=!certpath:%replacepath%=!
set certfile=!certfile:.pem=!
set certfile=!certfile:.cacert=!
set certfile=AddedByUser !certfile!
FOR /D %%P IN ("%appdata%\Mozilla\Firefox\Profiles\*") DO (
"%~dp0bin\certutil.exe" -A -n "!certfile!" -i "%%C" -t "cTC,cTC,cTC", -d "%%P"
))
setlocal DISABLEDELAYEDEXPANSION


REM #### postcheck (check only on default profile, not individual user profiles)
setlocal ENABLEDELAYEDEXPANSION
set replacepath=%~dp0cacert\
FOR /R "%~dp0" %%C IN (cacert\*.pem) DO (
set certpath=%%C
set certfile=!certpath:%replacepath%=!
set certfile=!certfile:.pem=!
set certfile=!certfile:.cacert=!
set certfile=AddedByUser !certfile!
"%~dp0bin\certutil.exe" -L -d "%firefoxdefaultprofile%" | findstr /i "!certfile!" >NUL
set myerrorlevel=%errorlevel%
if /i "!myerrorlevel!" NEQ "0" echo [ERR2] post-check: certificate not in db "!firefoxdefaultprofile!": !certfile!
if /i "!myerrorlevel!" NEQ "0" exit /B 2
)
setlocal DISABLEDELAYEDEXPANSION


REM #### eof
exit /B 0