@ECHO OFF
SET "rootpath=%~1"
FOR /D %%D IN ("%rootpath%\*") DO (
  FOR /F %%K IN ('DIR /A-D "%%D" 2^>NUL ^| FIND "File(s)" ^|^| ECHO 0') DO (
    ECHO %%D: %%K
  )
)