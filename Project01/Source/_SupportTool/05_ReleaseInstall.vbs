Option Explicit

'--------------------------------------------------
'��Include Standard Software Library
'--------------------------------------------------
'FileName�ɂ͑��΃A�h���X���w��\
'--------------------------------------------------
'Include ".\Test\..\..\StandardSoftwareLibrary_vbs\StandardSoftwareLibrary.vbs"  
Call Include(".\Lib\StandardSoftwareLibrary.vbs")

Sub Include(ByVal FileName)
    Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject") 
    Dim Stream: Set Stream = fso.OpenTextFile( _
        fso.GetParentFolderName(WScript.ScriptFullName) _
        + "\" + FileName, 1)
    ExecuteGlobal Stream.ReadAll() 
    Call Stream.Close
End Sub
'--------------------------------------------------

'------------------------------
'�����C������
'------------------------------
Call Main

Sub Main
    Dim MessageText: MessageText = ""

    Dim IniFilePath: IniFilePath = _
        PathCombine(Array(ScriptFolderPath, "SupportTool.ini"))

    Dim IniFile: Set IniFile = New IniFile
    Call IniFile.Initialize(IniFilePath)

    '--------------------
    '�E�ݒ�Ǎ�
    '--------------------
    Dim ProjectName: ProjectName = _
        IniFile.ReadString("Option", "ProjectName", "")

    Dim InstallParentFolderPath: InstallParentFolderPath = _
        IniFile.ReadString("Option", "InstallParentFolderPath", "")

    Dim OverWriteIgnoreFiles: OverWriteIgnoreFiles = _
        IniFile.ReadString("Option", "OverWriteIgnoreFiles", "")
    '--------------------

    Dim NowValue: NowValue = Now
    Dim ReleaseFolderPath: ReleaseFolderPath = _
        PathCombine(Array( _
            "..\..\Release", _
            "Recent", _
            ProjectName))
    ReleaseFolderPath = _
        AbsoluteFilePath(ScriptFolderPath, ReleaseFolderPath)

    Dim InstallFolderPath: InstallFolderPath = _
        PathCombine(Array( _
            InstallParentFolderPath, _
            ProjectName))

    If not fso.FolderExists(ReleaseFolderPath) Then
        WScript.Echo _
            "�R�s�[���t�H���_��������܂���" + vbCrLF + _
            ReleaseFolderPath
        Exit Sub
    End If

    If not fso.FolderExists(InstallParentFolderPath) Then
        WScript.Echo _
            "�C���X�g�[����e�t�H���_��������܂���" + vbCrLF + _
            InstallParentFolderPath
        Exit Sub
    End If

    Call CopyFolderOverWriteIgnoreFile(ReleaseFolderPath, InstallFolderPath, OverWriteIgnoreFiles)

    MessageText = MessageText + _
        fso.GetFileName(InstallFolderPath) + vbCrLf

    WScript.Echo _
        "Finish " + WScript.ScriptName + vbCrLf + _
        "----------" + vbCrLf + _
        Trim(MessageText)
End Sub

