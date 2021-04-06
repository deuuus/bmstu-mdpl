ml /c read.asm main.asm
ml /c print.asm
link main.obj read.obj print.obj, app.exe, , , ,
del main.obj
del read.obj
del print.obj
del app.map