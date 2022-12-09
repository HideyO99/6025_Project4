!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"

; Name the installer
OutFile "6025_Project4.exe"

var /GLOBAL All_drives
Var /GLOBAL num_drives
var disk_total_size
var disk_free_size

;Page 
!define MUI_WELCOMEPAGE_TITLE "Welcome"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "get_drives"
!define MUI_WELCOMEPAGE_TEXT "You have drives "
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_LICENSE "text.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM


Function get_drives
    ${GetDrives} "HDD" "DisplayDrives"
    SendMessage $mui.WelcomePage.Text ${WM_SETTEXT} 0 "STR:$(MUI_TEXT_WELCOME_INFO_TEXT)You have $num_drives drives$\r$\n$All_drives"
FunctionEnd

Function DisplayDrives
    ;MessageBox MB_OK  "$9 (0 $0 1 $1 2 $2 3 $3 4 $4 5 $5 6 $6 7 $7 8 $8 9 $9  Drive)"
    ${DriveSpace} $9 "/D=T /S=G" $disk_total_size
    ${DriveSpace} $9 "/D=F /S=G" $disk_free_size
    IntOp $num_drives $num_drives + 1
    StrCpy $All_drives "$All_drives $9 has free $disk_free_size GB of total capacity $disk_total_size GB$\r$\n"

    push $0
    # your code here
FunctionEnd


; Create a section for the installer
Section "Core Section" CoreSection
    

    ; your code here
    ;MessageBox MB_OK "Let's create a Hello_World.txt on our Desktop"

    ; First we need to open a file called "Hello_World.txt",
    ; on the desktop in write mode. This file does not need
    ; to exist
    ;FileOpen $0 "$DESKTOP\Hello_World.txt" w #<-- Don't forget this

    ; Write to the file
    ;FileWrite $0 "Hello World!"

    ; Make sure you close the file when you are done with it
    ;FileClose $0

    ;MessageBox MB_OK "We created a text file on your desktop!"

SectionEnd

Section "Readme"

SectionEnd

; Uninstaller
Section "un.install"

SectionEnd