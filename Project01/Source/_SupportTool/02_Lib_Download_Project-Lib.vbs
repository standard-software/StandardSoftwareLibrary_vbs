Option Explicit

Dim ProjectFolderName: ProjectFolderName = _
    "Project01"

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

'----------
'�E���ݒ�
Dim Library_Source_Path: Library_Source_Path = _
    "..\..\..\" + _
    "Source\StandardSoftwareLibrary_vbs\StandardSoftwareLibrary.vbs"
Dim Library_Dest_Path: Library_Dest_Path = _
    "..\" + _
    ProjectFolderName + _
    "\Lib\StandardSoftwareLibrary.vbs"
'----------

Call Main

Sub Main
    Dim MessageText: MessageText = ""

    Dim SourcePath: SourcePath = _
        AbsoluteFilePath(ScriptFolderPath, Library_Source_Path)
    If not fso.FileExists(SourcePath) Then
        WScript.Echo _
            "�R�s�[���t�@�C����������܂���" + vbCrLF + _
            SourcePath
        Exit Sub
    End If

    Dim DestPath: DestPath = _
        AbsoluteFilePath(ScriptFolderPath, Library_Dest_Path)
    If not fso.FolderExists(fso.GetParentFolderName(DestPath)) Then
        WScript.Echo _
            "�R�s�[��t�H���_��������܂���" + vbCrLF + _
            fso.GetParentFolderName(DestPath)
        Exit Sub
    End If
        
    Call ForceCreateFolder(fso.GetParentFolderName(DestPath))

    Call fso.CopyFile(SourcePath, DestPath)
    MessageText = SourcePath + vbCrLf + _
        ">> " + DestPath
    WScript.Echo _
        "Finish " + WScript.ScriptName + vbCrLf + _
        "----------" + vbCrLf + _
        Trim(MessageText)
End Sub