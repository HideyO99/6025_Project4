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
!insertmacro MUI_PAGE_LICENSE "EULA_en.txt"
!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;uninstall page
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Function .onInit
${If} ${RunningX64}
StrCpy $INSTDIR "$PROGRAMFILES64\${ProductName}"
${Else}
StrCpy $INSTDIR "$PROGRAMFILES\${ProductName}"
${EndIf}
MessageBox MB_OK "Please close any running applications"
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
Section "Core Section" SectionCore
    
    SetOutPath $INSTDIR
    ;MessageBox MB_OK $INSTDIR
    ${If} ${RunningX64}
        SetRegView 64
    ${Else}
        SetRegView 32
    ${EndIf}
    ReadRegStr $0 HKLM Software\CND\Chinsaengchai_Siraphong "INFO-6025"
    StrCmp $0 "" label_install label_abort
    label_install:
    WriteRegStr HKLM Software\CND\Chinsaengchai_Siraphong "INFO-6025" "INFO-6025" 
    
    ;copy files
    file /r Siraphong_Chinsaengchai\*.*
    ;create shortcut
    CreateShortcut "$desktop\Chinsaengchai_Siraphong.lnk" "$INSTDIR\6025_Project4.exe"

    WriteRegStr HKLM Software\CND\Chinsaengchai_Siraphong "INFO-6025" "INFO-6025" 
    WriteUninstaller "$INSTDIR\uninstaller.exe"
    Goto label_end

    label_abort:
    MessageBox MB_OK "Program already installed"
    
    ;Abort
    Quit
    label_end:
SectionEnd


Section "Readme" ExtraAddons
    SetOutPath $INSTDIR

    file /r ReadMe.txt

    ;WriteUninstaller "$INSTDIR\uninstaller.exe"
SectionEnd

LangString DESC_SecCore ${LANG_ENGLISH} "Core Section"
LangString DESC_ExtraAddons ${LANG_ENGLISH} "Readme Section"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SectionCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${ExtraAddons} $(DESC_ExtraAddons)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller
Section "Uninstall"
    ${If} ${RunningX64}
        SetRegView 64
    ${Else}
        SetRegView 32
    ${EndIf}

    Delete "$INSTDIR\uninstaller.exe"
    Delete "$INSTDIR\ReadMe.txt"
    Delete "$INSTDIR\asset\model\*"
    Delete "$INSTDIR\asset\*"
    Delete "$INSTDIR\src\shader\*"
    Delete "$INSTDIR\src\*"
    Delete "$INSTDIR\*"

    DeleteRegKey HKLM Software\CND\Chinsaengchai_Siraphong
    
    RMDir /r "$INSTDIR" 

SectionEnd