!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

; Name the installer
OutFile "6025_Project4.exe"

;Product name
!define ProductName "CND"
Name "6025 Project4"

;var
var All_drives
Var num_drives
var disk_total_size
var disk_free_size



;Page 
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "get_drives"
!insertmacro MUI_PAGE_WELCOME
!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_LICENSE "text.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_LANGUAGE "English"

Function .onInit
${If} ${RunningX64}
StrCpy $INSTDIR "$PROGRAMFILES64\${ProductName}"
${Else}
StrCpy $INSTDIR "$PROGRAMFILES\${ProductName}"
${EndIf}
FunctionEnd

Function get_drives
    ${GetDrives} "HDD" "DisplayDrives"
    SendMessage $mui.WelcomePage.Text ${WM_SETTEXT} 0 "STR:$(MUI_TEXT_WELCOME_INFO_TEXT)$\r$\nYou have $num_drives drives$\r$\n$All_drives"
    StrCpy $All_drives ""
    StrCpy $num_drives ""
FunctionEnd

Function DisplayDrives
    ;get each drive total capacity
    ${DriveSpace} $9 "/D=T /S=G" $disk_total_size
    ;get available space from each drive
    ${DriveSpace} $9 "/D=F /S=G" $disk_free_size
    ;count num drive
    IntOp $num_drives $num_drives + 1
    ;append string 
    StrCpy $All_drives "$All_drives $9 has free $disk_free_size GB of total capacity $disk_total_size GB$\r$\n"

    push $0
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