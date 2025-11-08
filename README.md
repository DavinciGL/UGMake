# UGMake
Addition to the GMake Repository by our friend, Banshee302.

**It is primarily written for Windows and is tested in a Windows enviroment but does not use any kernel features so Linux SHOULD work too.**

# Commands
./gmake.exe runs gmake
./gmake.exe (taskname)

you should type in a task you wrote in your GMake file, so say ./gmake.exe build which will run the build task if its written in your GMake file.

# Documentation
You can generate a minimal GMake file with the UGMake-GMake-Generator utility, which is built into the program, you can do it by doing ./gmake.exe --init . which will init a gmake file in the current directory and scan all files and add a compiler into it.

You can do code checksum validations by putting:
verify(<taskname>)
in your task, replace <taskname> with the task its inside of.

    # UNDER THE HOOD
<img width="721" height="571" alt="gmakediagram" src="https://github.com/user-attachments/assets/640c5c12-7237-4dc6-8648-13b44cc0f8a8" />

    
