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
    Dim LibrarySourceFilePathList: LibrarySourceFilePathList = ""

    'LibrarySourcePath01/02/03...�Ƃ���Ini�t�@�C�����ڂ̓ǂݎ��
    Dim I: I = 1
    Do While IniFile.SectionIdentExists("Option", "LibrarySourcePath" + LongToStrDigitZero(I, 2))
        LibrarySourceFilePathList = LibrarySourceFilePathList + _
            IniFile.ReadString("Option", "LibrarySourcePath"  + LongToStrDigitZero(I, 2), "") + vbCrLf
        I = I + 1
    Loop
    LibrarySourceFilePathList = ExcludeLastStr(LibrarySourceFilePathList, vbCrLf)

    Dim ProjectName: ProjectName = _
        IniFile.ReadString("Option", "ProjectName", "")

    Dim LibraryDestFolderPath: LibraryDestFolderPath = _
        "..\" + _
        ProjectName + _
        "\Lib"
    '--------------------

    Dim DestFolderPath: DestFolderPath = _
        AbsoluteFilePath(ScriptFolderPath, LibraryDestFolderPath)

    If not fso.FolderExists(DestFolderPath) Then
        WScript.Echo _
            "�R�s�[��t�H���_��������܂���" + vbCrLF + _
            fso.GetParentFolderName(DestFolderPath)
        Exit Sub
    End If

    Dim FilePaths: FilePaths = Split(LibrarySourceFilePathList, vbCrLf)

    If ArrayCount(FilePaths) = 0 Then
        WScript.Echo _
            "�R�s�[��t�@�C����������܂���" + vbCrLF + _
            LibrarySourceFilePathList
        Exit Sub
    End If

    Dim FilePath
    For I = 0 To ArrayCount(FilePaths) - 1
        FilePath = FilePaths(I)

        Dim SourcePath: SourcePath = _
            AbsoluteFilePath(ScriptFolderPath, FilePath)
        If not fso.FileExists(SourcePath) Then
            WScript.Echo _
                "�R�s�[���t�@�C����������܂���" + vbCrLF + _
                SourcePath
            Exit Sub
        End If

        Call fso.CopyFile(SourcePath, IncludeLastPathDelim(DestFolderPath), True)
        MessageText = MessageText + _
            fso.GetFileName(SourcePath) + ">> " + fso.GetFileName(DestFolderPath) + vbCrLf
    Next

    WScript.Echo _
        "Finish " + WScript.ScriptName + vbCrLf + _
        "----------" + vbCrLf + _
        Trim(MessageText)
End Sub