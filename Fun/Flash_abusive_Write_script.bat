:: My FDxICSP programmer has been tested 10000+ times Write and Read without any error on an Attiny13a
:: This script added more tolerant to the error. 

@echo off
SETLOCAL EnableDelayedExpansion
Set /a "WriteCounter=0"
Set /a "ErrorCounter=0"
echo ***************************************************************
echo Abusive Flash write endurant life cycle Test:
echo ***************************************************************

:Write
::timeout 1
Set /a "WriteCounter=!WriteCounter!+1"
echo 88v Written !WriteCounter! times 1>> C:\AVR\log.txt
echo 88v Written !WriteCounter! times
C:\AVR\avrdude\v72\avrdude.exe -c AVR910 -p m88 -b 1000000 -x devcode=3 -F -P COM3 -U flash:w:"C:\AVR\RD8K.txt":r
if %errorlevel% GTR  0 ( Set /a "ErrorCounter=!ErrorCounter!+1" 
echo 88v Written Failed here !ErrorCounter! time
)

Set /a "WriteCounter=!WriteCounter!+1"
echo 88v Written !WriteCounter! times 1>> C:\AVR\log.txt
echo 88v Written !WriteCounter! times
C:\AVR\avrdude\v72\avrdude.exe -c AVR910 -p m88 -b 1000000 -x devcode=3 -F -P COM3 -U flash:w:"C:\AVR\RD8K2.txt":r
if %errorlevel% GTR  0 ( Set /a "ErrorCounter=!ErrorCounter!+1" 
echo 88v Written Failed here !ErrorCounter! time
)
if !ErrorCounter! GTR  30 ( GOTO Done )
goto Write

:Done
echo Failed at writing !WriteCounter! times 1>> C:\AVR\log.txt
echo Failed at writing !WriteCounter! times
pause
