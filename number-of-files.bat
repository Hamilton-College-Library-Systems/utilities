@echo off

 FOR /D %%G in ("*") DO (
     PUSHD "%%G"
     FOR /F "delims=" %%H in ('dir /a-d /b * ^|find /C /V ""') DO echo %%G %%H>>"..\count.txt"
     POPD
 )