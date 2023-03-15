
@echo off
SET COMPORT=COM3


:loop
cls
echo.
echo CARguru - Helper
echo.
echo Bitte waehlen Sie eine der folgenden Optionen:
echo. 
echo  1 - COM-Port festlegen
echo  2 - Upload fuer CARguru vorbereiten auf %COMPORT%
echo  3 - Putty starten
echo  4 - SPIFFS-Dateien erzeugen und auf %COMPORT% hochladen
echo  5 - Bridge-Software hochladen auf %COMPORT%
echo. 
echo  x - Beenden
echo.
set /p SELECTED=Ihre Auswahl: 

if "%SELECTED%" == "x" goto :eof
if "%SELECTED%" == "1" goto :SetComPort
if "%SELECTED%" == "2" goto :CARguru
if "%SELECTED%" == "3" goto :Putty
if "%SELECTED%" == "4" goto :SPIFFS
if "%SELECTED%" == "5" goto :bridge
goto :errorInput 


:SetComPort
echo  1 - Setze COM-Port 1
echo  2 - Setze COM-Port 2
echo  3 - Setze COM-Port 3
echo  4 - Setze COM-Port 4
echo  5 - Setze COM-Port 5
echo  6 - Setze COM-Port 6
echo  7 - Setze COM-Port 7
echo  8 - Setze COM-Port 8
echo  9 - Setze COM-Port 9
echo  10 - Setze COM-Port 10
echo  x - Exit
echo.
set /p SELECTED=Ihre Auswahl: 

if "%SELECTED%" == "x" goto :loop
 
if "%SELECTED%" == "1" (
set COMPORT=COM1
goto :loop
)
if "%SELECTED%" == "2" (
set COMPORT=COM2
goto :loop
)
if "%SELECTED%" == "3" (
set COMPORT=COM3
goto :loop
)
if "%SELECTED%" == "4" (
set COMPORT=COM4
goto :loop
)
if "%SELECTED%" == "5" (
set COMPORT=COM5
goto :loop
)
if "%SELECTED%" == "6" (
set COMPORT=COM6
goto :loop
)
if "%SELECTED%" == "7" (
set COMPORT=COM7
goto :loop
)
if "%SELECTED%" == "8" (
set COMPORT=COM8
goto :loop
)
if "%SELECTED%" == "9" (
set COMPORT=COM9
goto :loop
)
if "%SELECTED%" == "10" (
set COMPORT=COM10
goto :loop
)
goto :errorInput 

pause
goto :loop

:CARguru
@echo on
esptool.exe -p %COMPORT% -b 460800 --before default_reset --after hard_reset --chip esp32 write_flash --flash_mode dio --flash_freq 80m --flash_size detect 0x00001000 show_IP-Address/bootloader.bin 0x00008000 show_IP-Address/partitions.bin 0x00010000 show_IP-Address/firmware.bin
@echo off
echo.
pause
goto :loop

:Putty
@echo on
Putty\putty.exe -serial %COMPORT% -sercfg 115200,8,n,1,N
@echo off
echo.
pause
goto :loop

:SPIFFS
@echo on
mkspiffs.exe -c SPIFFS  -s 0x16F000 -b 4096 -p 256 -- spiffs.bin
esptool.exe --chip esp32 --port %COMPORT% --baud 115200 write_flash -z 0x291000 spiffs.bin
@echo off
echo.
pause
goto :loop

:bridge
@echo on
esptool.exe -p %COMPORT% -b 460800 --before default_reset --after hard_reset --chip esp32 write_flash --flash_mode dio --flash_freq 80m --flash_size detect 0x00001000 carguru-bridge/bootloader.bin 0x00008000 carguru-bridge/partitions.bin 0x00010000 carguru-bridge/firmware.bin
@echo off
echo.
pause
goto :loop

:errorInput
echo.
echo Falsche Eingabe! Bitte erneut versuchen!
echo.
pause
goto :loop
