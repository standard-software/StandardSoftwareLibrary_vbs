'--------------------------------------------------
'Standard Software Library For VBScript
'
'ModuleName:    StandardSoftwareLibrary.vbs
'--------------------------------------------------
'�o�[�W����     2015/01/26
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

'--------------------------------------------------
'������
'--------------------------------------------------

'----------------------------------------
'���e�X�g
'----------------------------------------
Call test01

Public Sub test01
'    Call WScript.Echo("test")
'    Call WScript.Echo(vbObjectError)
'    Call testAssert
'    Call testCheck
'    Call testOrValue
'    Call testLoadTextFile
'    Call testSaveTextFile
'    Call testFirstStrFirstDelim
'    Call testFirstStrLastDelim
'    Call testLastStrFirstDelim
'    Call testLastStrLastDelim

    Call testIsFirstStr()
    Call testIncludeFirstStr()
    Call testExcludeFirstStr()
    Call testIsLastStr()
    Call testIncludeLastStr()
    Call testExcludeLastStr()

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

'----------------------------------------
'�������񏈗�
'----------------------------------------

'------------------------------
'��First/Last Include/Exclude
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
'   UTF-16BE BOM�L��    UNICODEFEFF
'   UTF-16BE BOM����    UTF-16BE
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
    Call Check("����������", LoadTextFile("TestLoadTextFile\SJIS_File.txt", "Shift_JIS"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-7_File.txt", "UTF-7"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-8_File.txt", "UTF-8"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-8_File.txt", "UTF-8N"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-8N_File.txt", "UTF-8N"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-8N_File.txt", "UTF-8"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16BEBOM����_File.txt", "UTF-16BE"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16BEBOM�L��_File.txt", "UNICODEFEFF"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM����_File.txt", "UTF-16"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM����_File.txt", "UTF-16LE"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM����_File.txt", "UNICODE"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM����_File.txt", "UNICODEFFFE"))

    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM�L��_File.txt", "UTF-16"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM�L��_File.txt", "UTF-16LE"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM�L��_File.txt", "UNICODE"))
    Call Check("����������", LoadTextFile("TestLoadTextFile\UTF-16LEBOM�L��_File.txt", "UNICODEFFFE"))
End Sub

'------------------------------
'���e�L�X�g�t�@�C���ۑ�
'�G���R�[�h�w��͉��L�̒ʂ�
'   �G���R�[�h          �w�蕶��
'   ShiftJIS            SHIFT_JIS
'   UTF-16LE BOM�L��    UNICODEFFFE/UNICODE/UTF-16
'   UTF-16LE BOM����    UTF-16LE
'   UTF-16BE BOM�L��    UNICODEFEFF
'   UTF-16BE BOM����    UTF-16BE
'   UTF-8 BOM�L��       UTF-8
'   UTF-8 BOM����       UTF-8N
'   JIS                 ISO-2022-JP
'   EUC-JP              EUC-JP
'   UTF-7               UTF-7
'UTF-16LE��UTF-8�͂��̂܂܂���BOM�L��ɂȂ�̂�
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
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\SJIS_File.txt", "Shift_JIS")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-7_File.txt", "UTF-7")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-8_File.txt", "UTF-8")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-8N_File.txt", "UTF-8N")

    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16BEBOM����_File.txt", "UTF-16BE")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16BEBOM�L��_File.txt", "UNICODEFEFF")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16LEBOM����_File.txt", "UTF-16LE")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16LEBOM�L��1_File.txt", "UNICODEFFFE")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16LEBOM�L��2_File.txt", "UNICODE")
    Call SaveTextFile("123ABC����������", "TestSaveTextFile\UTF-16LEBOM�L��3_File.txt", "UTF-16")
End Sub

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
'   
'--------------------------------------------------
