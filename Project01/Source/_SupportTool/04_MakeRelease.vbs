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
    Dim Library_Source_Path: Library_Source_Path = _
        IniFile.ReadString("Option", "LibrarySourcePath", "")

    Dim ProjectName: ProjectName = _
        IniFile.ReadString("Option", "ProjectName", "")
    '--------------------

    Dim NowValue: NowValue = Now
    Dim ReleaseFolderPath: ReleaseFolderPath = _
        PathCombine(Array( _
            "..\..\\Release", _
            "Recent", _
            ProjectName))

    Dim SourceFolderPath: SourceFolderPath = _
        "..\..\Source\" + _
        ProjectName
    SourceFolderPath = _
        AbsoluteFilePath(ScriptFolderPath, SourceFolderPath)

    If not fso.FolderExists(SourceFolderPath) Then
        WScript.Echo _
            "�R�s�[���t�H���_��������܂���" + vbCrLF + _
            SourceFolderPath
        Exit Sub
    End If

    '�t�H���_�Đ����R�s�[
    Call ReCreateCopyFolder(SourceFolderPath, ReleaseFolderPath)

    MessageText = MessageText + _
        fso.GetFileName(SourceFolderPath) + vbCrLf

    '�o�[�W�������t�@�C��
    Dim VersionInfoFilePath: VersionInfoFilePath = _
        "..\..\version.txt"
    VersionInfoFilePath = _
        AbsoluteFilePath(ScriptFolderPath, VersionInfoFilePath)
    If fso.FileExists(VersionInfoFilePath) Then
        Call fso.CopyFile( _
            VersionInfoFilePath, _
                IncludeLastPathDelim(ReleaseFolderPath) + _
                fso.GetFileName(VersionInfoFilePath))
    End If

    WScript.Echo _
        "Finish " + WScript.ScriptName + vbCrLf + _
        "----------" + vbCrLf + _
        Trim(MessageText)

End Sub

