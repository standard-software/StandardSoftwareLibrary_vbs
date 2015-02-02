'--------------------------------------------------
'Standard Software Library For VBScript
'
'ModuleName:    StandardSoftwareLibrary.vbs
'--------------------------------------------------
'version        2015/02/02
'--------------------------------------------------

'--------------------------------------------------
'���}�[�N
'--------------------------------------------------

    '--------------------------------------------------
    '��
    '--------------------------------------------------

    '----------------------------------------
    '��
    '----------------------------------------

    '------------------------------
    '��
    '------------------------------

    '--------------------
    '�E
    '--------------------

Option Explicit

'--------------------------------------------------
'���萔/�^�錾
'--------------------------------------------------

'----------------------------------------
'��FileSystemObject
'----------------------------------------
Public fso: Set fso = CreateObject("Scripting.FileSystemObject")

'----------------------------------------
'��Shell
'----------------------------------------
Public Shell: Set Shell = WScript.CreateObject("WScript.Shell")

'--------------------------------------------------
'������
'--------------------------------------------------

'----------------------------------------
'���e�X�g
'----------------------------------------
Public Sub test
'    Call WScript.Echo("test")
'    Call WScript.Echo(vbObjectError)
''    Call testAssert
'    Call testCheck
'    Call testOrValue
'    Call testLoadTextFile
'    Call testSaveTextFile
'    Call testFirstStrFirstDelim
'    Call testFirstStrLastDelim
'    Call testLastStrFirstDelim
'    Call testLastStrLastDelim
'    Call testIsFirstStr()
'    Call testIncludeFirstStr()
'    Call testExcludeFirstStr()
'    Call testIsLastStr()
'    Call testIncludeLastStr()
'    Call testExcludeLastStr()
'    Call testTrimFirstStrs
'    Call testTrimLastStrs
    Call testStringCombine

'    Call testAbsoluteFilePath
    Call testPeriodExtName
    Call testExcludePathExt
    Call testChangeFileExt
    Call testPathCombine
End Sub

'----------------------------------------
'���������f
'----------------------------------------

'--------------------
'�EAssert
'--------------------
'Assert = �咣����
'Err�ԍ� vbObjectError + 1 ��
'���[�U�[��`�G���[�ԍ���1
'���삳����Ǝ��̂悤�ɃG���[�_�C�A���O���\�������
'   �G���[: Message�̓��e
'   �R�[�h: 80040001
'   �\�[�X: Sub Assert
'--------------------
Public Sub Assert(ByVal Value, ByVal Message)
    If Value = False Then
        Call Err.Raise(vbObjectError + 1, "Sub Assert", Message)
    End If
End Sub

Private Sub testAssert()
    Call Assert(False, "�e�X�g")
End Sub

'--------------------
'�ECheck
'--------------------
'2�̒l���r���Ĉ�v���Ȃ����
'���b�Z�[�W���o���֐�
'--------------------
Public Function Check(ByVal A, ByVal B)
    Check = (A = B)
    If Check = False Then
        Call WScript.Echo("A <> B" + vbCrLf + _
            "A = " + CStr(A) + vbCrLf + _
            "B = " + CStr(B))
    End If
End Function

Private Sub testCheck()
    Call Check(10, 20)
End Sub

'--------------------
'�EOrValue
'--------------------
'��FIf OrValue(ValueA, Array(1, 2, 3)) Then
'--------------------
Public Function OrValue(ByVal Value, ByVal Values)
    OrValue = False
    Dim I
    For I = LBound(Values) To UBound(Values)
        If Value = Values(I) Then
            OrValue = True
            Exit For
        End If
    Next
End Function

Private Sub testOrValue()
    Call Check(True, OrValue(10, Array(20, 30, 40, 10)))
    Call Check(False, OrValue(50, Array(20, 30, 40, 10)))
End Sub

'--------------------
'�EIIF
'--------------------
Function IIF(CompareValue, Result1, Result2)
    If CompareValue Then
        IIF = Result1
    Else
        IIf = Result2
    End If
End Function


'----------------------------------------
'�������񏈗�
'----------------------------------------

'------------------------------
'��First Include/Exclude
'------------------------------
Public Function IsFirstStr(ByVal Str , ByVal SubStr)
    Dim Result: Result = False
    Do
        If SubStr = "" Then Exit Do
        If Str = "" Then Exit Do
        If Len(Str) < Len(SubStr) Then Exit Do
        
        If InStr(1, Str, SubStr) = 1 Then
            Result = True
        End If
    Loop While False
    IsFirstStr = Result
End Function

Private Sub testIsFirstStr()
    Call Check(True, IsFirstStr("12345", "1"))
    Call Check(True, IsFirstStr("12345", "12"))
    Call Check(True, IsFirstStr("12345", "123"))
    Call Check(False, IsFirstStr("12345", "23"))
    Call Check(False, IsFirstStr("", "34"))
    Call Check(False, IsFirstStr("12345", ""))
    Call Check(False, IsFirstStr("123", "1234"))
End Sub

Public Function IncludeFirstStr(ByVal Str, ByVal SubStr)
    If IsFirstStr(Str, SubStr) Then
        IncludeFirstStr = Str
    Else
        IncludeFirstStr = SubStr + Str
    End If
End Function

Private Sub testIncludeFirstStr()
    Call Check("12345", IncludeFirstStr("12345", "1"))
    Call Check("12345", IncludeFirstStr("12345", "12"))
    Call Check("12345", IncludeFirstStr("12345", "123"))
    Call Check("2312345", IncludeFirstStr("12345", "23"))
End Sub

Public Function ExcludeFirstStr(ByVal Str, ByVal SubStr)
    If IsFirstStr(Str, SubStr) Then
        ExcludeFirstStr = Mid(Str, Len(SubStr) + 1)
    Else
        ExcludeFirstStr = Str
    End If
End Function

Private Sub testExcludeFirstStr()
    Call Check("2345", ExcludeFirstStr("12345", "1"))
    Call Check("345", ExcludeFirstStr("12345", "12"))
    Call Check("45", ExcludeFirstStr("12345", "123"))
    Call Check("12345", ExcludeFirstStr("12345", "23"))
End Sub

'------------------------------
'��Last Include/Exclude
'------------------------------
Public Function IsLastStr(ByVal Str, ByVal SubStr)
    Dim Result: Result = False
    Do
        If SubStr = "" Then Exit Do
        If Str = "" Then Exit Do
        If Len(Str) < Len(SubStr) Then Exit Do
        
        If Right(Str, Len(SubStr)) = SubStr Then
            Result = True
        End If
    Loop While False
    IsLastStr = Result
End Function

Private Sub testIsLastStr()
    Call Check(True, IsLastStr("12345", "5"))
    Call Check(True, IsLastStr("12345", "45"))
    Call Check(True, IsLastStr("12345", "345"))
    Call Check(False, IsLastStr("12345", "34"))
    Call Check(False, IsLastStr("", "34"))
    Call Check(False, IsLastStr("12345", ""))
    Call Check(False, IsLastStr("123", "1234"))
End Sub

Public Function IncludeLastStr(ByVal Str, ByVal SubStr)
    If IsLastStr(Str, SubStr) Then
        IncludeLastStr = Str
    Else
        IncludeLastStr = Str + SubStr
    End If
End Function

Private Sub testIncludeLastStr()
    Call Check("12345", IncludeLastStr("12345", "5"))
    Call Check("12345", IncludeLastStr("12345", "45"))
    Call Check("12345", IncludeLastStr("12345", "345"))
    Call Check("1234534", IncludeLastStr("12345", "34"))
End Sub

Public Function ExcludeLastStr(ByVal Str, ByVal SubStr)
    If IsLastStr(Str, SubStr) Then
        ExcludeLastStr = Mid(Str, 1, Len(Str) - Len(SubStr))
    Else
        ExcludeLastStr = Str
    End If
End Function

Private Sub testExcludeLastStr()
    Call Check("1234", ExcludeLastStr("12345", "5"))
    Call Check("123", ExcludeLastStr("12345", "45"))
    Call Check("12", ExcludeLastStr("12345", "345"))
    Call Check("12345", ExcludeLastStr("12345", "34"))
End Sub

'------------------------------
'��Both
'------------------------------
Public Function IncludeBothEndsStr(ByVal Str, ByVal SubStr)
    IncludeBothEndsStr = _
        IncludeFirstStr(IncludeLastStr(Str, SubStr), SubStr)
End Function

Public Function ExcludeBothEndsStr(ByVal Str, ByVal SubStr)
    ExcludeBothEndsStr = _
        ExcludeFirstStr(ExcludeLastStr(Str, SubStr), SubStr)
End Function

'------------------------------
'��First/Last Delimiter
'------------------------------

'--------------------
'�EFirstStrFirstDelim
'--------------------
Public Function FirstStrFirstDelim(ByVal Value, ByVal Delimiter)
    Dim Result: Result = ""
    Dim Index: Index = InStr(Value, Delimiter)
    If 1 <= Index Then
        Result = Left(Value, Index - 1)
    End If
    FirstStrFirstDelim = Result
End Function

Private Sub testFirstStrFirstDelim
    Call Check("123", FirstStrFirstDelim("123,456", ","))
    Call Check("123", FirstStrFirstDelim("123,456,789", ","))
    Call Check("123", FirstStrFirstDelim("123ttt456", "ttt"))
    Call Check("123", FirstStrFirstDelim("123ttt456", "tt"))
    Call Check("123", FirstStrFirstDelim("123ttt456", "t"))
    Call Check("", FirstStrFirstDelim("123ttt456", ","))
End Sub

'--------------------
'�EFirstStrLastDelim
'--------------------
Public Function FirstStrLastDelim(ByVal Value, ByVal Delimiter)
    Dim Result: Result = ""
    Dim Index: Index = InStrRev(Value, Delimiter)
    If 1 <= Index Then
        Result = Left(Value, Index - 1)
    End If
    FirstStrLastDelim = Result
End Function

Private Sub testFirstStrLastDelim
    Call Check("123", FirstStrLastDelim("123,456", ","))
    Call Check("123,456", FirstStrLastDelim("123,456,789", ","))
    Call Check("123", FirstStrLastDelim("123ttt456", "ttt"))
    Call Check("123t", FirstStrLastDelim("123ttt456", "tt"))
    Call Check("123tt", FirstStrLastDelim("123ttt456", "t"))
    Call Check("", FirstStrLastDelim("123ttt456", ","))
End Sub

'--------------------
'�ELastStrFirstDelim
'--------------------
Public Function LastStrFirstDelim(ByVal Value, ByVal Delimiter)
    Dim Result: Result = ""
    Dim Index: Index = InStr(Value, Delimiter)
    If 1 <= Index Then
        Result = Mid(Value, Index + Len(Delimiter))
    End If
    LastStrFirstDelim = Result
End Function

Private Sub testLastStrFirstDelim
    Call Check("456", LastStrFirstDelim("123,456", ","))
    Call Check("456,789", LastStrFirstDelim("123,456,789", ","))
    Call Check("456", LastStrFirstDelim("123ttt456", "ttt"))
    Call Check("t456", LastStrFirstDelim("123ttt456", "tt"))
    Call Check("tt456", LastStrFirstDelim("123ttt456", "t"))
    Call Check("", LastStrFirstDelim("123ttt456", ","))
End Sub

'--------------------
'�ELastStrLastDelim
'--------------------
Public Function LastStrLastDelim(ByVal Value, ByVal Delimiter)
    Dim Result: Result = ""
    Dim Index: Index = InStrRev(Value, Delimiter)
    If 1 <= Index Then
        Result = Mid(Value, Index + Len(Delimiter))
    End If
    LastStrLastDelim = Result
End Function

Private Sub testLastStrLastDelim
    Call Check("456", LastStrLastDelim("123,456", ","))
    Call Check("789", LastStrLastDelim("123,456,789", ","))
    Call Check("456", LastStrLastDelim("123ttt456", "ttt"))
    Call Check("456", LastStrLastDelim("123ttt456", "tt"))
    Call Check("456", LastStrLastDelim("123ttt456", "t"))
    Call Check("", LastStrLastDelim("123ttt456", ","))
End Sub

'------------------------------
'��Trim
'------------------------------
Public Function TrimFirstStrs(ByVal Str, ByVal TrimStrs)
    Assert IsArray(TrimStrs), "Error:TrimFirstStrs:TrimStrs is not Array."
    Dim Result: Result = Str
    Do
        Str = Result
        Dim I
        For I = LBound(TrimStrs) To UBound(TrimStrs)
            Result = ExcludeFirstStr(Result, TrimStrs(I))
        Next
    Loop While Result <> Str
    TrimFirstStrs = Result
End Function

Private Sub testTrimFirstStrs
    Call Check("123 ",              TrimFirstStrs("   123 ", Array(" ")))
    Call Check(vbTab + "  123 ",    TrimFirstStrs("   " + vbTab + "  123 ", Array(" ")))
    Call Check("123 ",              TrimFirstStrs("   " + vbTab + "  123 ", Array(" ", vbTab)))
End Sub

Public Function TrimLastStrs(ByVal Str, ByVal TrimStrs)
    Assert IsArray(TrimStrs), "Error:TrimLastStrs:TrimStrs is not Array."
    Dim Result: Result = Str
    Do
        Str = Result
        Dim I
        For I = LBound(TrimStrs) To UBound(TrimStrs)
            Result = ExcludeLastStr(Result, TrimStrs(I))
        Next
    Loop While Result <> Str
    TrimLastStrs = Result
End Function

Private Sub testTrimLastStrs
    Call Check(" 123",           TrimLastStrs(" 123   ", Array(" ")))
    Call Check(" 123  " + vbTab, TrimLastStrs(" 123  " + vbTab + "   ", Array(" ")))
    Call Check(" 123",           TrimLastStrs(" 123  " + vbTab + "   ", Array(" ", vbTab)))
End Sub

Public Function TrimBothEndsStrs(ByVal Str, ByVal TrimStrs)
    TrimBothEndsStrs = _
        TrimFirstStrs(TrimLastStrs(Str, TrimStrs), TrimStrs)
End Function

'------------------------------
'�������񌋍�
'���Ȃ��Ƃ�1��Delimiter���Ԃɓ����Đڑ������B
'Delimiter�������̗��[�ɕt������ꍇ��1�ɂȂ�B
'2�A���Ō����̗��[�ɂ���ꍇ��1���폜�����(�e�X�g�ł̓���Q��)
'------------------------------
Public Function StringCombine(ByVal Delimiter, ByVal Values)
    Assert IsArray(Values), "Error:StringCombine:Values is not Array."
    Dim Result: Result = ""
    Dim Count: Count = ArrayCount(Values)
    If Count = 0 Then

    ElseIf Count = 1 Then
        Result = Values(0)
    Else
        Dim I
        For I = 0 To Count - 2
        Do
            If Values(I) = "" Then Exit Do
            If IsFirstStr(Values(I + 1), Delimiter) Then
                Result = Result + ExcludeLastStr(Values(I), Delimiter)
            Else
                Result = Result + IncludeLastStr(Values(I), Delimiter)
            End If
        Loop While False
        Next
        Result = Result + Values(Count - 1)
    End If
    StringCombine = Result
End Function

Private Sub testStringCombine()
    Call Check("1.2.3.4", StringCombine(".", Array("1", "2", "3", "4")))
    Call Check("1.2", StringCombine(".", Array("1.", "2")))
    Call Check("1.2", StringCombine(".", Array("1.", ".2")))
    Call Check("1..2", StringCombine(".", Array("1..", "2")))
    Call Check("1..2", StringCombine(".", Array("1", "..2")))

    Call Check("1..2", StringCombine(".", Array("1..", ".2")))
    Call Check("1..2", StringCombine(".", Array("1.", "..2")))
    Call Check("1...2", StringCombine(".", Array("1..", "..2")))

    Call Check("1.2.3", StringCombine(".", Array("1.", ".2", "3")))
    Call Check("1.2.3", StringCombine(".", Array("1.", ".2.", "3")))
    Call Check("1.2.3", StringCombine(".", Array("1.", ".2", ".3")))
    Call Check("1.2.3", StringCombine(".", Array("1.", ".2.", ".3")))

    Call Check("1.2.3..4", StringCombine(".", Array("1.", ".2", "3", "..4")))
    Call Check("1..2.3..4", StringCombine(".", Array("1..", ".2", "3.", "..4")))
    Call Check(".1..2.3..4..", StringCombine(".", Array(".1..", ".2", "3.", "..4..")))
End Sub

'----------------------------------------
'���t�@�C���t�H���_�p�X
'----------------------------------------

'--------------------
'�E��΃p�X���擾����֐�
'�J�����g�f�B���N�g���p�X�Ƒ��΃p�X���w�肷��
'--------------------
Function AbsoluteFilePath(BasePath, RelativePath)
    Dim Result
    Do
        If fso.FolderExists(BasePath) = False Then
            Result = RelativePath
            Exit Do
        End If
        
        '���΃p�X�w�蕔������΃p�X�̏ꍇ�A
        '�����͍s�킸�ɂ��̂܂ܐ�΃p�X��Ԃ�
        If IsIncludeDrivePath(RelativePath) Then
            Result = RelativePath
            Exit Do
        End If
        
        '���΃p�X�w�蕔�����l�b�g���[�N�p�X�̏ꍇ�A
        '�����͍s�킸�ɂ��̂܂ܐ�΃p�X��Ԃ�
        If IsNetworkPath(RelativePath) Then
            Result = RelativePath
            Exit Do
        End If

        '�J�����g�f�B���N�g�����m��
        Dim CurDirBuffer
        CurDirBuffer = Shell.CurrentDirectory
        
        Shell.CurrentDirectory = BasePath
        
        '���΃p�X���擾
        Result = fso.GetAbsolutePathName(RelativePath)
        
        '�J�����g�f�B���N�g�������ɖ߂�
        Shell.CurrentDirectory =  CurDirBuffer
    
    Loop While False
    AbsoluteFilePath = Result
End Function

Sub testAbsoluteFilePath()

     '�ʏ�̑��΃p�X�w��
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Windows", ".\System32")))
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Program Files", "..\Windows\System32")))
    
    '�s���I�h�ł͂Ȃ����΃p�X�w��
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Windows", "System32")))
    
    '�h���C�u�p�X�w��
    Call Check(LCase("C:\Program Files"), LCase(AbsoluteFilePath("C:\Windows", "C:\Program Files")))
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Program Files", "C:\Windows\System32")))
    
    '�l�b�g���[�N�p�X�w��
    Call Check(LCase("\\127.0.0.1\C$"), LCase(AbsoluteFilePath("C:\Windows", "\\127.0.0.1\C$")))

    MsgBox "Test OK"
End Sub

'--------------------
'�E�h���C�u�p�X���܂܂�Ă��邩�ǂ����m�F����֐�
'[:]��2�����ڈȍ~�ɂ��邩�ǂ����Ŕ���
'--------------------
Function IsIncludeDrivePath(Path)
    Dim Result
    Result = (2 <= InStr(Path, ":"))
    IsIncludeDrivePath = Result
End Function
'
'--------------------
'�E�l�b�g���[�N�h���C�u���ǂ����m�F����֐�
'--------------------
Function IsNetworkPath(Path)
    Dim Result: Result = False
    If IsFirstStr(Path, "\\") Then
        If 3 <= Len(Path) Then
            Result = True
        End If
    End If
    IsNetworkPath = Result
End Function
'
'--------------------
'�E�h���C�u�p�X"C:"�����o���֐�
'--------------------
Function GetDrivePath(Path)
    Dim Result: Result = ""
    If (2 <= InStr(Path, ":")) Then
        Result = FirstStrFirstDelim(Path, ":")
        Result = IncludeLastStr(Result, ":")
    End If
    GetDrivePath = Result
End Function

'--------------------
'�E�I�[�Ƀp�X��؂��ǉ�����֐�
'--------------------
Function IncludeLastPathDelim(Path)
    Dim Result: Result = ""
    If Path <> "" Then
        Result = IncludeLastStr(Path, "\")
    End If
    IncludeLastPathDelim = Result
End Function

'--------------------
'�E�I�[����p�X��؂���폜����֐�
'--------------------
Function ExcludeLastPathDelim(Path)
    Dim Result: Result = ""
    If Path <> "" Then
        Result = ExcludeLastStr(Path, "\")
    End If
    ExcludeLastPathDelim = Result
End Function

'--------------------
'�E�s���I�h���܂ފg���q���擾����
'�s���I�h�̂Ȃ��t�@�C�����̏ꍇ�͋󕶎���Ԃ�
'fso.GetExtensionName �ł̓s���I�h�ŏI���t�@�C������
'���f�ł��Ȃ����߂ɍ쐬�����B
'--------------------
Function PeriodExtName(Path)
    Dim Result: Result = ""
    Result = fso.GetExtensionName(Path)
    If IsLastStr(Path, "." + Result) Then
        Result = "." + Result
    End If
    PeriodExtName = Result
End Function

Sub testPeriodExtName
    Call Check(".txt", PeriodExtName("C:\temp\test.txt"))
    Call Check(".zip", PeriodExtName("C:\temp\test.tmp.zip"))
    Call Check("", PeriodExtName("C:\temp\test"))
    Call Check(".", PeriodExtName("C:\temp\test."))
End Sub

'--------------------
'�E�t�@�C��������g���q����菜���֐�
'--------------------
Function ExcludePathExt(Path)
    Dim Result: Result = ""
    If Path <> "" Then
        Result = ExcludeLastStr(Path, PeriodExtName(Path))
    End If
    ExcludePathExt = Result
End Function

Sub testExcludePathExt
    Call Check("C:\temp\test",      ExcludePathExt("C:\temp\test.txt"))
    Call Check("C:\temp\test.tmp",  ExcludePathExt("C:\temp\test.tmp.zip"))
    Call Check("C:\temp\test",      ExcludePathExt("C:\temp\test"))
    Call Check("C:\temp\test",      ExcludePathExt("C:\temp\test."))
End Sub

'--------------------
'�E�t�@�C���p�X�̊g���q��V�������̂ɂ���
'--------------------
Function ChangeFileExt(Path, NewExt)
    Dim Result: Result = ""
    If Path <> "" Then
        NewExt = IIF(NewExt = "", "", IncludeFirstStr(NewExt, "."))
        Result = ExcludePathExt(Path) + NewExt
    End If
    ChangeFileExt = Result
End Function

Sub testChangeFileExt
    Call Check("C:\temp\test.zip",      ChangeFileExt("C:\temp\test.txt", "zip"))
    Call Check("C:\temp\test.7z.tmp",      ChangeFileExt("C:\temp\test.txt", ".7z.tmp"))
    Call Check("C:\temp\test.tmp.7z",   ChangeFileExt("C:\temp\test.tmp.zip", "7z"))
    Call Check("C:\temp\test.",         ChangeFileExt("C:\temp\test", "."))
    Call Check("C:\temp\test",          ChangeFileExt("C:\temp\test.", ""))
End Sub

'--------------------
'�E�t�@�C���p�X����������
'--------------------
Function PathCombine(Values)
    Call Assert(IsArray(Values), "Error:PathCombine")
    PathCombine = StringCombine("\", Values)
End Function

Sub testPathCombine()
    Call Check("C:\Temp\Temp\temp.txt", PathCombine(Array("C:", "Temp", "Temp", "temp.txt")))
    Call Check("C:\Temp\Temp\temp.txt", PathCombine(Array("C:\Temp", "Temp\temp.txt")))
    Call Check("C:\Temp\Temp\temp.txt", PathCombine(Array("C:\Temp\Temp\", "\temp.txt")))
    Call Check("\Temp\Temp\", PathCombine(Array("\Temp\", "\Temp\")))

    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work",    "bbb\a.txt")))
    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work\",   "bbb\a.txt")))
    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work",    "\bbb\a.txt")))
    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work\",   "\bbb\a.txt")))

    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work",    "bbb",  "a.txt")))
    Call Check("C:\work\bbb\a.txt", PathCombine(Array("C:\work\",   "\bbb\","\a.txt")))

    Call Check("\C:\work\bbb\a.txt\", PathCombine(Array("\C:\work\",  "\bbb\","\a.txt\")))

End Sub


'--------------------
'�E�J�����g�f�B���N�g���̎擾
'--------------------
Function CurrentDirectory
    GetCurrentDirectory = Shell.CurrentDirectory
End Function

'--------------------
'�E�X�N���v�g�t�H���_�̎擾
'--------------------
Function ScriptFolderPath
    ScriptFolderPath = _
        fso.GetParentFolderName(WScript.ScriptFullName)
End Function


'----------------------------------------
'���e�L�X�g�t�@�C���ǂݏ���
'----------------------------------------

Public Function CheckEncodeName(ByVal EncodeName)
    CheckEncodeName = OrValue(UCase(EncodeName), Array(_
        "SHIFT_JIS", _
        "UNICODE", "UNICODEFFFE", "UTF-16LE", "UTF-16", _
        "UNICODEFEFF", _
        "UTF-16BE", _
        "UTF-8", _
        "UTF-8N", _
        "ISO-2022-JP", _
        "EUC-JP", _
        "UTF-7") )
End Function

'------------------------------
'���e�L�X�g�t�@�C���Ǎ�
'�G���R�[�h�w��͉��L�̒ʂ�
'   �G���R�[�h          �w�蕶��
'   ShiftJIS            SHIFT_JIS
'   UTF-16LE BOM�L/��   UNICODEFFFE/UNICODE/UTF-16/UTF-16LE
'                       BOM�̗L���Ɋւ�炸�Ǎ��\
'   UTF-16BE _BOM_ON    UNICODEFEFF
'   UTF-16BE _BOM_OFF    UTF-16BE
'   UTF-8 BOM�L/��      UTF-8/UTF-8N
'                       BOM�̗L���Ɋւ�炸�Ǎ��\
'   JIS                 ISO-2022-JP
'   EUC-JP              EUC-JP
'   UTF-7               UTF-7
'UTF-16LE��UTF-8�́ABOM�̗L���ɂ�����炸�ǂݍ��߂�
'------------------------------
Const StreamTypeEnum_adTypeBinary = 1
Const StreamTypeEnum_adTypeText = 2
Const StreamReadEnum_adReadAll = -1
Const StreamReadEnum_adReadLine = -2
Const SaveOptionsEnum_adSaveCreateOverWrite = 2

Public Function LoadTextFile( _
ByVal TextFilePath, ByVal EncodeName)

    If CheckEncodeName(EncodeName) = False Then
        Call Assert(False, "Error:LoadTextFile")
    End If

    Dim Stream: Set Stream = CreateObject("ADODB.Stream")
    Stream.Type = StreamTypeEnum_adTypeText

    Select Case UCase(EncodeName)
    Case "UTF-8N"
        Stream.Charset = "UTF-8"
    Case Else
        Stream.Charset = EncodeName
    End Select
    Call Stream.Open
    Call Stream.LoadFromFile(TextFilePath)
    LoadTextFile = Stream.ReadText
    Call Stream.Close
End Function

Private Sub testLoadTextFile()
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\SJIS_File.txt", "Shift_JIS"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-7_File.txt", "UTF-7"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-8_File.txt", "UTF-8"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-8_File.txt", "UTF-8N"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-8N_File.txt", "UTF-8N"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-8N_File.txt", "UTF-8"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16BE_BOM_OFF_File.txt", "UTF-16BE"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16BE_BOM_ON_File.txt", "UNICODEFEFF"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16LE"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UNICODE"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UNICODEFFFE"))

    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UTF-16"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UTF-16LE"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODE"))
    Call Check("123ABC����������", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODEFFFE"))
End Sub

'------------------------------
'���e�L�X�g�t�@�C���ۑ�
'�G���R�[�h�w��͉��L�̒ʂ�
'   �G���R�[�h          �w�蕶��
'   ShiftJIS            SHIFT_JIS
'   UTF-16LE _BOM_ON    UNICODEFFFE/UNICODE/UTF-16
'   UTF-16LE _BOM_OFF    UTF-16LE
'   UTF-16BE _BOM_ON    UNICODEFEFF
'   UTF-16BE _BOM_OFF    UTF-16BE
'   UTF-8 _BOM_ON       UTF-8
'   UTF-8 _BOM_OFF       UTF-8N
'   JIS                 ISO-2022-JP
'   EUC-JP              EUC-JP
'   UTF-7               UTF-7
'UTF-16LE��UTF-8�͂��̂܂܂���_BOM_ON�ɂȂ�̂�
'BON�����w��̏ꍇ�͓��ꏈ�������Ă���
'------------------------------
Public Sub SaveTextFile(ByVal Text, _
ByVal TextFilePath, ByVal EncodeName)
    If CheckEncodeName(EncodeName) = False Then
        Call Assert(False, "Error:SaveTextFile")
    End If

    Dim Stream: Set Stream = CreateObject("ADODB.Stream")
    Stream.Type = StreamTypeEnum_adTypeText

    Select Case UCase(EncodeName)
    Case "UTF-8N"
        Stream.Charset = "UTF-8"
    Case Else
        Stream.Charset = EncodeName
    End Select
    Call Stream.Open
    Call Stream.WriteText(Text)
    Dim ByteData
    Select Case UCase(EncodeName)
    Case "UTF-16LE"
        Stream.Position = 0
        Stream.Type = StreamTypeEnum_adTypeBinary
        Stream.Position = 2
        ByteData = Stream.Read
        Stream.Position = 0
        Call Stream.Write(ByteData)
        Call Stream.SetEOS
    Case "UTF-8N"
        Stream.Position = 0
        Stream.Type = StreamTypeEnum_adTypeBinary
        Stream.Position = 3
        ByteData = Stream.Read
        Stream.Position = 0
        Call Stream.Write(ByteData)
        Call Stream.SetEOS
    End Select
    Call Stream.SaveToFile(TextFilePath, _
        SaveOptionsEnum_adSaveCreateOverWrite)
    Call Stream.Close
End Sub

Private Sub testSaveTextFile()
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\SJIS_File.txt", "Shift_JIS")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-7_File.txt", "UTF-7")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-8_File.txt", "UTF-8")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-8N_File.txt", "UTF-8N")

    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16BE_BOM_OFF_File.txt", "UTF-16BE")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16BE_BOM_ON_File.txt", "UNICODEFEFF")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16LE")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODEFFFE")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16LE_BOM_ON2_File.txt", "UNICODE")
    Call SaveTextFile("123ABC����������", "Test\TestSaveTextFile\UTF-16LE_BOM_ON3_File.txt", "UTF-16")
End Sub

'----------------------------------------
'���z�񏈗�
'----------------------------------------

'--------------------
'�E�z��̒��������߂�֐�
'--------------------
Function ArrayCount(ByVal ArrayValue)
    Assert IsArray(ArrayValue), "Error:ArrayCount:ArrayValue is not Array."
    ArrayCount = UBound(ArrayValue) - LBound(ArrayValue) + 1
End Function

'--------------------------------------------------
'������
'�� ver 2015/01/20
'�E �쐬
'�E Assert/Check/OrValue
'�E fso
'�E TestStandardSoftwareLibrary.vbs/Include
'�E LoadTextFile/SaveTextFile
'�� ver 2015/01/21
'�E FirstStrFirstDelim/FirstStrLastDelim
'   /LastStrFirstDelim/LastStrLastDelim
'�� ver 2015/01/26
'�E IsFirstStr/IncludeFirstStr/ExcludeFirstStr
'   /IsLastStr/IncludeLastStr/ExcludeLastStr
'�� ver 2015/01/27
'�E ArrayCount
'�E TrimFirstStrs/TrimLastStrs/TrimBothEndsStrs
'�E StringCombine
'�� ver 2015/02/02
'�E Shell�I�u�W�F�N�g
'�E CurrentDirectory/ScriptFolderPath
'�E AbsoluteFilePath
'   IsNetworkPath/GetDrivePath
'   IsIncludeDrivePath/IncludeLastPathDelim/ExcludeLastPathDelim
'   /PeriodExtName/ExcludePathExt/ChangeFileExt
'   /PathCombine
'�E IIF
'--------------------------------------------------
