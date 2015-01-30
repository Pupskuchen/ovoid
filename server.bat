@ECHO OFF

set OV_BIN=bin

IF /I "%PROCESSOR_ARCHITECTURE%" == "amd64" (
    set OV_BIN=bin64
)
IF /I "%PROCESSOR_ARCHITEW6432%" == "amd64" (
    set OV_BIN=bin64
)

start %OV_BIN%\ovoid.exe -gserver.log -d %*
