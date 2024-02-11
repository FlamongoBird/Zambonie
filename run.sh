#!/bin/bash
if [ -e main ]
then
    ./main
elif [ -e main.exe ]
then
    main.exe
else 
    nim c -r main.nim
fi