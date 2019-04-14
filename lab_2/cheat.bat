@echo off

IF [%2] == [1] ping -n 2 127.0.0.1 > nul
IF [%1] == [1] (
    call winrar a output.zip "input\*.*"
) ELSE (
    call winrar e output.zip "output\"
)