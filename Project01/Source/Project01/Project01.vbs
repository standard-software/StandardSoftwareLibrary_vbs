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


'-----
'�ݒ�


'-----

Call Main

Sub Main
Do
    Dim Args
    Set Args = WScript.Arguments

    If Args.Count = 0 Then
        MsgBox "�N���������w�肳��Ă��܂���B" + vbCrLf + _
            "�������~���܂�" 
        Exit Do
    End If

    Dim DownloadPath
    DownloadPath = PathCombine(Array( _
        GetEnvironmentalVariables("PROGRAMDATA"), _
        "StandardSoftware\DownloadFileOpen\Download"))
    Call ForceCreateFolder(DownloadPath)

    Dim CopyFileFlag
    CopyFileFlag = False

    Dim I
    For I = 0 to Args.Count - 1
        Dim FilePath: FilePath = Args(I)

        If UCase(fso.GetExtensionName(FilePath)) = UCase("lnk") then
            '�V���[�g�J�b�g�t�@�C���̏ꍇ�̓I���W�i���t�@�C�������蓖�Ă�
            FilePath = GetShortcutFileLinkPath(FilePath)
        End If

        If fso.FileExists(FilePath) Then

            '�����t�@�C���̍폜����
            Dim FileArray
            FileArray = Split(ExcludeLastStr( _
                GetFilePathListTopFolder(DownloadPath), vbCrLf), vbCrLf)
            Dim J
            For J = 0 to ArrayLength(FileArray) - 1
                If IsFirstStr(fso.GetFileName(FileArray(J)), _
                    fso.GetBaseName(FilePath)) Then
                    call fso.DeleteFile(FileArray(J), True)
                End IF
            Next

            CopyFileFlag = True
            Dim CopyToPath
            CopyToPath = IncludeLastPathDelim(DownloadPath) + _ 
                fso.GetBaseName(FilePath) + "_" + _
                FormatYYYYMMDDHHMMSS(Now()) + _
                "." + fso.GetExtensionName(FilePath)
            Call fso.CopyFile(FilePath, CopyToPath)

            Do While not fso.FileExists(CopyToPath)
            Loop

            '�ǂݎ���p�����ɂ���
            Dim File
            Set File = fso.GetFile(CopyToPath)
            File.Attributes = File.Attributes or 1

            Call ShellFileOpen(CopyToPath, vbNormalFocus, False)
        End If
    Next

    If CopyFileFlag = False Then
        MsgBox "�N�������Ƀt�@�C�����w�肳��Ă��܂���B" + vbCrLf + _
            "�������~���܂�" 
        Exit Do
    End If

    Loop While False
End Sub
