'--------------------------------------------------
'Standard Software Library For VBScript
'
'ModuleName:    Project01.vbs
'--------------------------------------------------
'version        2015/02/04
'--------------------------------------------------

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

Call Main

Sub Main
Do
    Dim NewProjectName: NewProjectName = InputBox("�V�����v���W�F�N�g������͂��Ă��������B")

    If NewProjectName = "" Then
        Call MsgBox("���͂�����܂���B"+ vbCrLf + _
            "�������I�����܂��B")
        Exit Do
    End If

    Dim NewProjectFolderPath: NewProjectFolderPath = _
        AbsoluteFilePath(ScriptFolderPath, "..\..\..\..\" + NewProjectName)
    If fso.FolderExists(NewProjectFolderPath) Then
        Call MsgBox("�v���W�F�N�g���͊��Ɏg���Ă��܂��B"+ vbCrLf + _
            "�������I�����܂��B")
        Exit Do
    End If

    '�v���W�F�N�g�t�H���_�ꎮ�R�s�[
    Call ForceCreateFolder(NewProjectFolderPath)
    Call CopyFolderIgnorePath( _
        AbsoluteFilePath(ScriptFolderPath, "..\..\..\Project01\Source"), _
        PathCombine(Array(NewProjectFolderPath, "Source")), _
        "CreateNewProject.vbs,SupportTool.ini")

    '�v���W�F�N�g�t�@�C�����̕ύX
    Call fso.MoveFile( _
        PathCombine(Array(NewProjectFolderPath, "Source", "Project01", "Project01.vbs")), _
        PathCombine(Array(NewProjectFolderPath, "Source", "Project01", NewProjectName + ".vbs")))
    Call fso.MoveFolder( _
        PathCombine(Array(NewProjectFolderPath, "Source", "Project01")), _
        PathCombine(Array(NewProjectFolderPath, "Source", NewProjectName)))

    'Ini�t�@�C���ݒ�
    Call CopyFile( _
        PathCombine(Array(ScriptFolderPath, "SupportTool.ini")), _
        PathCombine(Array(NewProjectFolderPath, "Source", "_SupportTool", "SupportTool.ini")))
    Dim IniFilePath: IniFilePath = _
        PathCombine(Array(NewProjectFolderPath, "Source", "_SupportTool", "SupportTool.ini"))
    Dim IniFile: Set IniFile = New IniFile
    Call IniFile.Initialize(IniFilePath)
    Call IniFile.WriteString( _
        "Option", "ProjectName", NewProjectName)
    IniFile.Update
    Set IniFile = Nothing

    '�o�[�W�����t�@�C���ݒu
    Dim VersionTxt: VersionTxt = _
        "��" + FormatYYYY_MM_DD(Now, "/") + "    ver 1.0.0" + vbCrLf + _
        "�E  �쐬"
    Call SaveTextFile(VersionTxt, _
        PathCombine(Array(NewProjectFolderPath, "version.txt")), _
        "Shift_JIS")

    Call MsgBox("�V�����v���W�F�N�g[" + NewProjectName + "]���쐬���܂����B" + vbCrLf + _
        "-----" + vbCrLf + _
        NewProjectFolderPath)

Loop While False
End Sub
