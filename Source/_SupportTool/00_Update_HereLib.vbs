Option Explicit

'--------------------------------------------------
'��Include st.vbs
'--------------------------------------------------
Sub Include(ByVal FileName)
    Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject") 
    Dim Stream: Set Stream = fso.OpenTextFile( _
        fso.GetParentFolderName(WScript.ScriptFullName) _
        + "\" + FileName, 1)
    Call ExecuteGlobal(Stream.ReadAll())
    Call Stream.Close
End Sub
'--------------------------------------------------
Call Include(".\Lib\st.vbs")
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
    Dim LibrarySourceFilePath: LibrarySourceFilePath = _
        IniFile.ReadString("Update_HereLib", "LibrarySourceFilePath", "")
    If LibrarySourceFilePath = "" Then
        WScript.Echo _
            "�ݒ肪�ǂݎ��Ă��܂���"
        Exit Sub
    End If
        
	Dim LibraryDestFilePath: LibraryDestFilePath = _
        IniFile.ReadString("Update_HereLib", "LibraryDestFilePath", "")
    If LibraryDestFilePath = "" Then
        WScript.Echo _
            "�ݒ肪�ǂݎ��Ă��܂���"
        Exit Sub
    End If
    '--------------------

    Dim SourcePath: SourcePath = _
        AbsolutePath(ScriptFolderPath, LibrarySourceFilePath)
    If not fso.FileExists(SourcePath) Then
        WScript.Echo _
            "�R�s�[���t�@�C����������܂���" + vbCrLF + _
            SourcePath
        Exit Sub
    End If

    Dim DestPath: DestPath = _
        AbsolutePath(ScriptFolderPath, LibraryDestFilePath)
    If not fso.FolderExists(fso.GetParentFolderName(DestPath)) Then
        WScript.Echo _
            "�R�s�[��t�@�C���̃t�H���_��������܂���" + vbCrLF + _
            SourcePath
        Exit Sub
    End If

    Call fso.CopyFile(SourcePath, DestPath)
    MessageText = SourcePath + vbCrLf + _
        ">> " + DestPath
    WScript.Echo _
        "Finish " + WScript.ScriptName + vbCrLf + _
        "----------" + vbCrLf + _
        Trim(MessageText)
End Sub