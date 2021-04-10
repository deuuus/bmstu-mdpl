ml /c read.asm main.asm
ml /c print.asm calc.asm
link main.obj read.obj print.obj calc.obj, app.exe, , , ,
del main.obj
del read.obj
del print.obj
del calc.obj
del app.map