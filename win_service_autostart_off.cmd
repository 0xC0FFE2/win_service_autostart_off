@echo off

for /f "tokens=*" %%s in ('sc query state^= all ^| findstr /i "SERVICE_NAME: HncUpdateService_"') do (
    set "line=%%s"
    call :ProcessHnc
)

set SERVICES=PhoneService Parsec V3Svc V3SPUpdater AhnLab TaskSchedulerService NvTelemetryContainer NvContainerLocalSystem NvContainerNetworkService XboxGipSvc XboxNetApiSvc

for %%s in (%SERVICES%) do (
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
    echo %%s - OK
)

exit /b

:ProcessHnc
setlocal ENABLEDELAYEDEXPANSION
set "name=!line:*SERVICE_NAME: =!"
sc stop "!name!" >nul 2>&1
sc config "!name!" start= disabled >nul 2>&1
echo !name! - OK
endlocal
goto :eof
