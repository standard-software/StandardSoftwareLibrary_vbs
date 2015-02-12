'--------------------------------------------------
'Standard Software Library For VBScript
'
'ModuleName:    Basic_Module
'FileName:      StandardSoftwareLibrary.vbs
'URL:           https://github.com/standard-software/StandardSoftwareLibrary_vbs
'License:       Dual License GPL or Commercial License
'--------------------------------------------------
'version        2015/02/10
'--------------------------------------------------

'--------------------------------------------------
'■マーク
'--------------------------------------------------

    '--------------------------------------------------
    '■
    '--------------------------------------------------

    '----------------------------------------
    '◆
    '----------------------------------------

    '------------------------------
    '◇
    '------------------------------

    '--------------------
    '・
    '--------------------

Option Explicit

'--------------------------------------------------
'■定数/型宣言
'--------------------------------------------------

'----------------------------------------
'◆FileSystemObject
'----------------------------------------
Public fso: Set fso = CreateObject("Scripting.FileSystemObject")

'----------------------------------------
'◆Shell
'----------------------------------------
Public Shell: Set Shell = WScript.CreateObject("WScript.Shell")

'--------------------------------------------------
'■実装
'--------------------------------------------------

'----------------------------------------
'◆テスト
'----------------------------------------
'Call test
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
'    Call testStringCombine

'    Call testAbsoluteFilePath
'    Call testPeriodExtName
'    Call testExcludePathExt
'    Call testChangeFileExt
'    Call testPathCombine
'    Call testFileFolderPathList

    Call testShellCommandRunReturn
'    Call testEnvironmentalVariables
'    Call testShellFileOpen
'    Call testShellCommandRun

'    Call testFormatYYYYMMDD
'    Call testFormatHHMMSS
'    Call testIniFile
'    Call testMatchText
'    Call testForceCreateFolder
    Call testMaxValue
    Call testMinValue
    Call testIsLong
    Call testLongToStrDigitZero
    Call testStrToLongDefault
End Sub

'----------------------------------------
'◆条件判断
'----------------------------------------

'--------------------
'・Assert
'--------------------
'Assert = 主張する
'Err番号 vbObjectError + 1 は
'ユーザー定義エラー番号の1
'動作させると次のようにエラーダイアログが表示される
'   エラー: Messageの内容
'   コード: 80040001
'   ソース: Sub Assert
'--------------------
Public Sub Assert(ByVal Value, ByVal Message)
    If Value = False Then
        Call Err.Raise(vbObjectError + 1, "Sub Assert", Message)
    End If
End Sub

Private Sub testAssert()
    Call Assert(False, "テスト")
End Sub

'--------------------
'・Check
'--------------------
'2つの値を比較して一致しなければ
'メッセージを出す関数
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
'・OrValue
'--------------------
'例：If OrValue(ValueA, Array(1, 2, 3)) Then
'--------------------
Public Function OrValue(ByVal Value, ByVal Values)
    Call Assert(IsArray(Values), "Error:OrValue:Values is not Array.")

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
'・IIF
'--------------------
Public Function IIF(ByVal CompareValue, ByVal Result1, ByVal Result2)
    If CompareValue Then
        IIF = Result1
    Else
        IIf = Result2
    End If
End Function

'----------------------------------------
'◆型、型変換
'----------------------------------------

'------------------------------
'◇Long
'------------------------------
Public Function IsLong(ByVal Value)
    Dim Result: Result = False
    If IsNumeric(Value) Then
        If CInt(Value) = CDbl(Value) Then
            Result = True
        End If
    End If
    IsLong = Result
End Function

Private Sub testIsLong()
    Call Check(True, IsLong("123"))
    Call Check(False, IsLong("12a"))
    Call Check(False, IsLong("123.4"))
End Sub

Public Function LongToStrDigitZero(ByVal Value, ByVal Digit)
    Dim Result: Result = ""
    If 0 <= Value Then
        Result = String(MaxValue(Array(0, Digit - Len(CStr(Value)))), "0") + CStr(Value)
    Else
        Result = "-" + String(Digit - Len(CStr(Abs(Value))), "0") + CStr(Abs(Value))
    End If
    LongToStrDigitZero = Result
End Function

Private Sub testLongToStrDigitZero()
    Call Check("003", LongToStrDigitZero(3, 3))
    Call Check("000", LongToStrDigitZero(0, 3))
    Call Check("1000", LongToStrDigitZero(1000, 3))
    Call Check("-050", LongToStrDigitZero(-50, 3))
End Sub

Public Function StrToLongDefault(ByVal S, ByVal Default)
On Error Resume Next
    Dim Result
    Result = Default
    Result = CLng(S)
    StrToLongDefault = Result
End Function

Private Sub testStrToLongDefault()
    Call Check(123, StrToLongDefault("123", 0))
    Call Check(123, StrToLongDefault(" 123 ", 0))
    Call Check(0, StrToLongDefault(" A123 ", 0))
    Call Check(123, StrToLongDefault("BBB", 123))
End Sub

'----------------------------------------
'◆数値処理
'----------------------------------------

'------------------------------
'◇最大値最小値
'------------------------------
'例：MsgBox MaxValue(Array(1, 2, 3))
'------------------------------
Public Function MaxValue(ByVal Values)
    Call Assert(IsArray(Values), "Error:OrValue:Values is not Array.")
    Dim Result: Result = Empty
    Dim Value
    For Each Value In Values
        If IsEmpty(Result) Then
            Result = Value
        ElseIf Result < Value Then
            Result = Value
        End If
    Next
    MaxValue = Result
End Function

Private Sub testMaxValue()
    Call Check(100, MaxValue(Array(50, 20, 30, 100, 9)))
End Sub

Public Function MinValue(ByVal Values)
    Dim Result: Result = Empty
    Dim Value
    For Each Value In Values
        If Result = Empty Then
            Result = Value
        ElseIf Result > Value Then
            Result = Value
        End If
    Next
    MinValue = Result
End Function

Private Sub testMinValue()
    Call Check(9, MinValue(Array(50, 20, 30, 100, 9)))
End Sub


'----------------------------------------
'◆文字列処理
'----------------------------------------

'------------------------------
'◇First Include/Exclude
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
'◇Last Include/Exclude
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
'◇Both  Include/Exclude
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
'◇First/Last Delimiter
'------------------------------

'--------------------
'・FirstStrFirstDelim
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
'・FirstStrLastDelim
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
'・LastStrFirstDelim
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
'・LastStrLastDelim
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
'◇Trim
'------------------------------
Public Function TrimFirstStrs(ByVal Str, ByVal TrimStrs)
    Call Assert(IsArray(TrimStrs), "Error:TrimFirstStrs:TrimStrs is not Array.")
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
    Call Assert(IsArray(TrimStrs), "Error:TrimLastStrs:TrimStrs is not Array.")
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
'◇文字列結合
'少なくとも1つのDelimiterが間に入って接続される。
'Delimiterが結合の両端に付属する場合も1つになる。
'2連続で結合の両端にある場合は1つが削除される(テストでの動作参照)
'------------------------------
Public Function StringCombine(ByVal Delimiter, ByVal Values)
    Call Assert(IsArray(Values), "Error:StringCombine:Values is not Array.")
    Dim Result: Result = ""
    Dim Count: Count = ArrayCount(Values)
    If Count = 0 Then

    ElseIf Count = 1 Then
        Result = Values(0)
    Else
        Dim I
        For I = 0 To Count - 1
        Do
            If Values(I) = "" Then Exit Do
            If Result = "" Then
                Result = Values(I)
            Else
                Result = _
                    ExcludeLastStr(Result, Delimiter) + _
                    Delimiter + _
                    ExcludeFirstStr(Values(I), Delimiter)
            End If

        Loop While False
        Next
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

    Call Check("", StringCombine(vbCrLf, Array("", "")))
    Call Check("", StringCombine(vbCrLf, Array("", "", "")))
    Call Check("A", StringCombine(vbCrLf, Array("A", "")))
    Call Check("A", StringCombine(vbCrLf, Array("A", "", "")))
    Call Check("A", StringCombine(vbCrLf, Array("", "A")))
    Call Check("A", StringCombine(vbCrLf, Array("", "", "A")))
    Call Check("A", StringCombine(vbCrLf, Array("", "A", "")))

    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("A", "B", "")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("A", "B", "", "")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "A", "B")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "", "A", "B")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "A", "B", "")))

    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("A", "", "B")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "A", "", "B")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("A", "", "B", "")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "A", "", "B", "")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("A", "", "", "B")))
    Call Check("A" + vbCrLf + "B", StringCombine(vbCrLf, Array("", "", "A", "", "", "B", "", "")))
End Sub

'----------------------------------------
'◆文字列比較
'----------------------------------------

'--------------------
'・ワイルドカード検索
'--------------------
'   ・  VBのLike演算子と似た文字列比較
'   ・  厳密には正規表現を利用しているので
'       正規表現文字が含まれていると誤動作する
'--------------------
Public Function LikeCompare(ByVal TargetText, ByVal WildCard)
    Dim Result: Result = False
    Dim Reg
    Set Reg = CreateObject("VBScript.RegExp")
    WildCard = Replace(WildCard, "*", ".*")
    WildCard = Replace(WildCard, "?", ".")
    Reg.Pattern = IncludeFirstStr(IncludeLastStr(WildCard, "$"), "^")
    Result = Reg.Test(TargetText)
    LikeCompare = Result
End Function

'--------------------
'・文字列一致を確認する関数
'--------------------
'   ・ 部分文字列(キーワード)かワイルドカードで一致確認する
'   ・ ワイルドカード指定かどうかは[*]か[?]が
'       含まれているかどうかで判定する
'--------------------
Public Function MatchText(ByVal TargetText, ByVal SearchStrArray)
    Call Assert(IsArray(SearchStrArray), "Error:MatchText:SearchStrArray is not Array.")
    Dim Result: Result = False
    Dim I
    For I = 0 To ArrayCount(SearchStrArray) - 1
        If (1 <= InStr(SearchStrArray(I), "*")) _
        Or (1 <= InStr(SearchStrArray(I), "?"))  Then
            'ワイルドカードマッチ
            If (LikeCompare(TargetText, SearchStrArray(I))) Then
                Result = True
                Exit For
            End If
        Else
            'キーワードマッチ
            If (1 <= InStr(TargetText, SearchStrArray(I))) Then
                Result = True
                Exit For
            End If
        End If
    Next
    MatchText = Result
End Function

Private Sub testMatchText
    Call Check(True, MatchText("aaa.ini", Array(".ini")))
    Call Check(False, MatchText("aaa.ini", Array("ab")))
    Call Check(False, MatchText("aaa.ini", Array("ab", "bc")))
    Call Check(True, MatchText("aaa.ini", Array("ab", "bc", "a.i")))
    Call Check(True, MatchText("aaa.ini", Array("*.ini")))
    Call Check(False, MatchText("aaa.ini", Array("*.txt")))
    Call Check(False, MatchText("aaa.ini", Array("*.txt", "123")))
    Call Check(True, MatchText("aaa.ini", Array("*.txt", "123", "*.ini")))
    Call Check(True, MatchText("aaa.ini", Array("*.txt", "123", "a.i")))
End Sub

'----------------------------------------
'◆配列処理
'----------------------------------------

'--------------------
'・配列の長さを求める関数
'--------------------
'LBound=0の配列のみを対象とする。
'--------------------
Public Function ArrayCount(ByVal ArrayValue)
    Call Assert(IsArray(ArrayValue), "Error:ArrayCount:ArrayValue is not Array.")
    Call Assert(LBound(ArrayValue) = 0, "Error:ArrayCount:ArrayValue is LBound != 0.")
    ArrayCount = UBound(ArrayValue) - LBound(ArrayValue) + 1
End Function

'--------------------
'・配列をスペースでつなげて文字列にする
'--------------------
Function ArrayText(ByVal ArrayValue)
    Call Assert(IsArray(ArrayValue), _
        "Error:Function ArrayText:ArgsArray is not array")

    Dim Result: Result = ""
    Dim I 
    For I = 0 To ArrayCount(ArrayValue) - 1
        ArrayValue(I) = InSpacePlusDoubleQuote(ArrayValue(I))
    Next
    Result = StringCombine(" ", ArrayValue)

    ArrayText = Result
End Function



'----------------------------------------
'◆日付時刻処理
'----------------------------------------

'--------------------
'・日付書式
'--------------------
Public Function FormatYYYYMMDD(ByVal DateValue)
    FormatYYYYMMDD = FormatYYYY_MM_DD(DateValue, "")
End Function

Sub testFormatYYYYMMDD
    Dim Value: Value = CDate("2015/02/03")
    Call Check("20150203", FormatYYYYMMDD(Value))
End Sub

Public Function FormatYYYY_MM_DD(ByVal DateValue, ByVal Delimiter)
    Dim Result: Result = ""
    Do
        If IsDate(DateValue) = False Then Exit Do

        Result = _
            Year(DateValue) & _
            Delimiter & _
            Right("0" & Month(DateValue), 2) & _
            Delimiter & _
            Right("0" & Day(DateValue), 2)
    Loop While False
    FormatYYYY_MM_DD = Result
End Function

'--------------------
'・時刻書式
'--------------------
Public Function FormatHHMMSS(ByVal TimeValue)
    FormatHHMMSS = FormatHH_MM_SS(TimeValue, "")
End Function

Sub testFormatHHMMSS
    Dim Value: Value = CDate("2015/02/03 05:05")
    Call Check("05:05:00", FormatHH_MM_SS(Value, ":"))
End Sub

Public Function FormatHH_MM_SS(ByVal TimeValue, ByVal Delimiter)
    Dim Result: Result = ""
    Do
        If IsDate(TimeValue) = False Then Exit Do 

        Result = _
            Right("0" & Hour(TimeValue) , 2) & _
            Delimiter & _
            Right("0" & Minute(TimeValue) , 2) & _
            Delimiter & _
            Right("0" & Second(TimeValue) , 2)
    Loop While False
    FormatHH_MM_SS = Result
End Function

'--------------------
'・日付時刻書式
'--------------------
Public Function FormatYYYYMMDDHHMMSS(ByVal DateTimeValue)
    FormatYYYYMMDDHHMMSS = _
        FormatYYYYMMDD(DateTimeValue) + _
        FormatHHMMSS(DateTimeValue)
End Function


'----------------------------------------
'◆ファイルフォルダパス処理
'----------------------------------------

'--------------------
'・絶対パスを取得する関数
'カレントディレクトリパスと相対パスを指定する
'--------------------
Public Function AbsoluteFilePath(ByVal BasePath, ByVal RelativePath)
    Dim Result
    Do
        If fso.FolderExists(BasePath) = False Then
            Result = RelativePath
            Exit Do
        End If
        
        '相対パス指定部分が絶対パスの場合、
        '処理は行わずにそのまま絶対パスを返す
        If IsIncludeDrivePath(RelativePath) Then
            Result = RelativePath
            Exit Do
        End If
        
        '相対パス指定部分がネットワークパスの場合、
        '処理は行わずにそのまま絶対パスを返す
        If IsNetworkPath(RelativePath) Then
            Result = RelativePath
            Exit Do
        End If

        'カレントディレクトリを確保
        Dim CurDirBuffer
        CurDirBuffer = Shell.CurrentDirectory
        
        Shell.CurrentDirectory = BasePath
        
        '相対パスを取得
        Result = fso.GetAbsolutePathName(RelativePath)
        
        'カレントディレクトリを元に戻す
        Shell.CurrentDirectory =  CurDirBuffer
    
    Loop While False
    AbsoluteFilePath = Result
End Function

Sub testAbsoluteFilePath()

     '通常の相対パス指定
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Windows", ".\System32")))
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Program Files", "..\Windows\System32")))
    
    'ピリオドではない相対パス指定
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Windows", "System32")))
    
    'ドライブパス指定
    Call Check(LCase("C:\Program Files"), LCase(AbsoluteFilePath("C:\Windows", "C:\Program Files")))
    Call Check(LCase("C:\Windows\System32"), LCase(AbsoluteFilePath("C:\Program Files", "C:\Windows\System32")))
    
    'ネットワークパス指定
    Call Check(LCase("\\127.0.0.1\C$"), LCase(AbsoluteFilePath("C:\Windows", "\\127.0.0.1\C$")))

    Call Check(AbsoluteFilePath(fso.GetParentFolderName(WScript.ScriptFullName), ".\Test\TestFileFolderPathList"), _
        fso.GetParentFolderName(WScript.ScriptFullName) + "\Test\TestFileFolderPathList")
    Call Check(AbsoluteFilePath(fso.GetParentFolderName(WScript.ScriptFullName), "..\Test\TestFileFolderPathList"), _
        fso.GetParentFolderName(fso.GetParentFolderName(WScript.ScriptFullName)) + "\Test\TestFileFolderPathList")

    MsgBox "Test OK"
End Sub

'--------------------
'・ドライブパスが含まれているかどうか確認する関数
'[:]が2文字目以降にあるかどうかで判定
'--------------------
Public Function IsIncludeDrivePath(ByVal Path)
    Dim Result
    Result = (2 <= InStr(Path, ":"))
    IsIncludeDrivePath = Result
End Function
'
'--------------------
'・ネットワークドライブかどうか確認する関数
'--------------------
Public Function IsNetworkPath(ByVal Path)
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
'・ドライブパス"C:"を取り出す関数
'--------------------
Public Function GetDrivePath(ByVal Path)
    Dim Result: Result = ""
    If IsIncludeDrivePath(Path) Then
        Result = FirstStrFirstDelim(Path, ":")
        Result = IncludeLastStr(Result, ":")
    End If
    GetDrivePath = Result
End Function

'--------------------
'・終端にパス区切りを追加する関数
'--------------------
Public Function IncludeLastPathDelim(ByVal Path)
    Dim Result: Result = ""
    If Path <> "" Then
        Result = IncludeLastStr(Path, "\")
    End If
    IncludeLastPathDelim = Result
End Function

'--------------------
'・終端からパス区切りを削除する関数
'--------------------
Public Function ExcludeLastPathDelim(ByVal Path)
    Dim Result: Result = ""
    If Path <> "" Then
        Result = ExcludeLastStr(Path, "\")
    End If
    ExcludeLastPathDelim = Result
End Function

'--------------------
'・スペースの含まれた値をダブルクウォートで囲う
'--------------------
Function InSpacePlusDoubleQuote(ByVal Value)
    Dim Result: Result = ""
    If 0 < InStr(Value, " ") Then
        Result = IncludeBothEndsStr(Value, """")
    Else
        Result = Value
    End If
    InSpacePlusDoubleQuote = Result
End Function


'--------------------
'・ピリオドを含む拡張子を取得する関数
'--------------------
'ピリオドのないファイル名の場合は空文字を返す
'fso.GetExtensionName ではピリオドで終わるファイル名を
'判断できないために作成した。
'--------------------
Public Function PeriodExtName(ByVal Path)
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
'・ファイル名から拡張子を取り除く関数
'--------------------
Public Function ExcludePathExt(ByVal Path)
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
'・ファイルパスの拡張子を変更する関数
'--------------------
Public Function ChangeFileExt(ByVal Path, ByVal NewExt)
    Dim Result: Result = ""
    If Path <> "" Then
        NewExt = IIF(NewExt = "", "", IncludeFirstStr(NewExt, "."))
        Result = ExcludePathExt(Path) + NewExt
    End If
    ChangeFileExt = Result
End Function

Sub testChangeFileExt
    Call Check("C:\temp\test.zip",      ChangeFileExt("C:\temp\test.txt", "zip"))
    Call Check("C:\temp\test.7z.tmp",   ChangeFileExt("C:\temp\test.txt", ".7z.tmp"))
    Call Check("C:\temp\test.tmp.7z",   ChangeFileExt("C:\temp\test.tmp.zip", "7z"))
    Call Check("C:\temp\test.",         ChangeFileExt("C:\temp\test", "."))
    Call Check("C:\temp\test",          ChangeFileExt("C:\temp\test.", ""))
End Sub

'--------------------
'・ファイルパスを結合する関数
'--------------------
Public Function PathCombine(ByVal Values)
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

'----------------------------------------
'◆ファイルフォルダパス取得
'----------------------------------------

'--------------------
'・カレントディレクトリの取得
'--------------------
Public Function CurrentDirectory
    GetCurrentDirectory = Shell.CurrentDirectory
End Function

'--------------------
'・スクリプトフォルダの取得
'--------------------
Public Function ScriptFolderPath
    ScriptFolderPath = _
        fso.GetParentFolderName(WScript.ScriptFullName)
End Function

'--------------------
'・一時ファイルの取得
'--------------------
Public Function TemporaryFilePath
    Dim Result
    Const TemporaryFolder = 2

    ' リダイレクト先のファイル名を生成。
    Do
        Result = fso.BuildPath( _
            fso.GetSpecialFolder(TemporaryFolder).Path, _
            fso.GetTempName)
    Loop While fso.FileExists(Result)
    TemporaryFilePath = Result
End Function

'----------------------------------------
'◆ファイルフォルダ列挙
'----------------------------------------

Sub testFileFolderPathList()
    Dim Path: Path = AbsoluteFilePath(ScriptFolderPath, ".\Test\TestFileFolderPathList")
    Dim PathList

    PathList = Replace(UCase(FolderPathListTopFolder(Path)), UCase(Path), "")
'    Call MsgBox(PathList)
    Call Check(PathList, _
        StringCombine(vbCrLf, Array( _
            "\AAA", _
            "\BBB" _
        )))

    PathList = Replace(UCase(FolderPathListSubFolder(Path)), UCase(Path), "")
'    Call MsgBox(PathList)
    Call Check(PathList, _
        StringCombine(vbCrLf, Array( _
            "\AAA", _
            "\AAA\AAA-1", _
            "\AAA\AAA-2", _
            "\AAA\AAA-2\AAA-2-1", _
            "\AAA\AAA-2\AAA-2-2", _
            "\AAA\AAA-2\AAA-2-2\AAA-2-2-1", _
            "\BBB", _
            "\BBB\BBB-1", _
            "\BBB\BBB-1\BBB-1-1", _
            "\BBB\BBB-1\BBB-1-1\BBB-1-1-1", _
            "\BBB\BBB-1\BBB-1-2", _
            "\BBB\BBB-2", "" _
        )))

    PathList = Replace(UCase(FilePathListTopFolder(Path)), UCase(Path), "")
'    Call MsgBox(PathList)
    Call Check(PathList, _
        StringCombine(vbCrLf, Array( _
            "\AAA.TXT", _
            "\BBB.TXT" _
        )))

    PathList = Replace(UCase(FilePathListSubFolder(Path)), UCase(Path), "")
'    Call MsgBox(PathList)
    Call Check(PathList, _
        StringCombine(vbCrLf, Array( _
            "\AAA\AAA-1.TXT", _
            "\AAA\AAA-2.TXT", _
            "\AAA\AAA-2\AAA-2-1.TXT", _
            "\AAA\AAA-2\AAA-2-2.TXT", _
            "\AAA\AAA-2\AAA-2-2\AAA-2-2-1.TXT", _
            "\BBB\BBB-1.TXT", _
            "\BBB\BBB-2.TXT", _
            "\BBB\BBB-1\BBB-1-1.TXT", _
            "\BBB\BBB-1\BBB-1-2.TXT", _
            "\BBB\BBB-1\BBB-1-1\BBB-1-1-1.TXT", _
            "\AAA.TXT", _
            "\BBB.TXT" _
        )))
End Sub

'------------------------------
'◇フォルダ
'------------------------------

'--------------------
'・トップレベルのフォルダリストを取得
'存在しなければ空文字を返す。
'パスは改行コードで区切られている
'--------------------
Public Function FolderPathListTopFolder(ByVal FolderPath)
    Dim Result: Result = ""
    Dim SubFolder
    For Each SubFolder In fso.GetFolder(FolderPath).SubFolders
        Result = StringCombine(vbCrLf, Array(Result, SubFolder.Path))
    Next
    FolderPathListTopFolder = Result
End Function

'--------------------
'・サブフォルダのフォルダリストを取得
'存在しなければ空文字を返す。
'パスは改行コードで区切られている
'--------------------
Public Function FolderPathListSubFolder(ByVal FolderPath)
    Dim Result: Result = ""
    Dim SubFolder 
    For Each SubFolder In fso.GetFolder(FolderPath).SubFolders
        Result = StringCombine(vbCrLf, _
            Array(Result, SubFolder.Path, FolderPathListSubFolder(SubFolder.Path)))
    Next
    FolderPathListSubFolder = Result
End Function

'------------------------------
'◇ファイル
'------------------------------

'--------------------
'・トップレベルのファイルリストを取得
'存在しなければ空文字を返す。
'パスは改行コードで区切られている
'--------------------
Public Function FilePathListTopFolder(ByVal FolderPath)
    Dim Result: Result = ""
    Dim File 
    For Each File In fso.GetFolder(FolderPath).Files
        Result = StringCombine(vbCrLf, Array(Result, File.Path))
    Next
    FilePathListTopFolder = ExcludeLastStr(Result, vbCrLf)
End Function

'--------------------
'・サブフォルダのファイルリストを取得
'存在しなければ空文字を返す。
'パスは改行コードで区切られている
'--------------------
Public Function FilePathListSubFolder(ByVal FolderPath)
    Dim Result: Result = ""
    Dim FolderPathList
    FolderPathList = Split( _
        FolderPathListSubFolder(FolderPath) + vbCrLf + FolderPath, vbCrLf)
    Dim I 
    For I = 0 To ArrayCount(FolderPathList) - 1
        'MsgBox FolderPathList(I)
        Result = StringCombine(vbCrLf, _
            Array(Result, FilePathListTopFolder(FolderPathList(I))))
    Next
    FilePathListSubFolder = ExcludeLastStr(Result, vbCrLf)
End Function


'----------------------------------------
'◆ファイルフォルダ処理
'----------------------------------------

'--------------------
'・深い階層のフォルダでも一気に作成する関数
'--------------------
Public Sub ForceCreateFolder(ByVal FolderPath)
    Dim ParentFolderPath
    ParentFolderPath = fso.GetParentFolderName(FolderPath)

    If fso.FolderExists(ParentFolderPath) = False Then
        Call ForceCreateFolder(ParentFolderPath)
    End If

    'フォルダが出来るまで繰り返す。
    '100回繰り返して無理ならエラー
    Dim I: I = 1
    On Error Resume Next
    Do Until fso.FolderExists(FolderPath)
        Call fso.CreateFolder(FolderPath)
        Call Assert(I < 100, "Error:ForceCreateFolder:Fail CreateFolder")
        I = I + 1
    Loop
End Sub

Private Sub testForceCreateFolder
    Call ForceDeleteFolder(AbsoluteFilePath(ScriptFolderPath, _
        ".\Test\TestForceCreateFolder"))
    Call ForceCreateFolder(AbsoluteFilePath(ScriptFolderPath, _
        ".\Test\TestForceCreateFolder\Test\Test"))
    Call MsgBox("OK")
End Sub

'--------------------
'・フォルダ削除を確認するまでDeleteFolderする関数
'--------------------
Public Sub ForceDeleteFolder(ByVal FolderPath)
    'フォルダがある間繰り返す。
    '100回繰り返して無理ならエラー
    Dim I: I = 1
    On Error Resume Next
    Do While fso.FolderExists(FolderPath)
        Call fso.DeleteFolder(FolderPath)
        Call Assert(I < 100, "Error:ForceDeleteFolder:Fail DeleteFolder")
        I = I + 1
    Loop
End Sub


'--------------------
'・ファイル削除を確認するまでDeleteFileする関数
'--------------------
Public Sub ForceDeleteFile(ByVal FilePath)
    'ファイルがある間繰り返す。
    '100回繰り返して無理ならエラー
    Dim I: I = 1
    On Error Resume Next
    Do While fso.FileExists(FolderPath)
        Call fso.DeleteFile(FolderPath, True)
        Call Assert(I < 100, "Error:ForceDeleteFile:Fail DeleteFile")
        I = I + 1
    Loop
End Sub

'--------------------
'・フォルダを再生成する関数
'--------------------
Public Sub ReCreateFolder(ByVal FolderPath)
    Call ForceDeleteFolder(FolderPath)
    Call ForceCreateFolder(FolderPath)
End Sub

'--------------------
'・フォルダを再生成してコピーする関数
'--------------------
'フォルダの日付が最新になる
'--------------------
Public Sub ReCreateCopyFolder( _
ByVal SourceFolderPath, ByVal DestFolderPath)

    Call Assert(fso.FolderExists(SourceFolderPath) = True, _
        "Error:ReCreateCopyFolder:Copy SourceFolder is not exists")

    Call ForceDeleteFolder(DestFolderPath)

    On Error Resume Next
    Do
        Call ForceCreateFolder(fso.GetParentFolderName(DestFolderPath))
        Call fso.CopyFolder( _
            SourceFolderPath, DestFolderPath, True)
    Loop Until fso.FolderExists(DestFolderPath)
    'フォルダが作成できるまでループ
End Sub

'--------------------
'・除外ファイルを指定したフォルダ内ファイルのコピー関数
'--------------------
'   ・インストール時などにiniファイルを除外して
'     上書きインストールするときに使用する
'   ・指定例：
'     OverWriteIgnore = "*.ini"
'     OverWriteIgnore = "*.ini,setting.txt"
'--------------------
Public Sub CopyFolderOverWriteIgnoreFile( _
ByVal SourceFolderPath, ByVal DestFolderPath, _
ByVal OverWriteIgnoreFiles)

    Dim FileList: FileList = _
        Split( _
            FilePathListSubFolder(SourceFolderPath), vbCrLf)

    Dim OverWrite
    Dim CopyDestFilePath
    Dim I
    For I = 0 To ArrayCount(FileList) - 1
    Do
        OverWrite = True
        '除外ファイル
        If MatchText(LCase(FileList(I)), Split(LCase(OverWriteIgnoreFiles), ",")) Then OverWrite = False

        CopyDestFilePath = _
            IncludeFirstStr( _
                ExcludeFirstStr(FileList(I), SourceFolderPath), _
                DestFolderPath)
        '上書き禁止ならファイルがあったらコピーしない
        If OverWrite = False Then
            If fso.FileExists(CopyDestFilePath) then
                Exit Do
            End If
        End If

        Call ForceCreateFolder(fso.GetParentFolderName(CopyDestFilePath))
        Call fso.CopyFile( _
            FileList(I), CopyDestFilePath, True)
    Loop While False
    Next
End Sub


'----------------------------------------
'◆ショートカットファイル操作
'----------------------------------------
Public Function ShortcutFileLinkPath(ByVal ShortcutFilePath)
    Dim Result: Result = ""
    Dim file: Set file = Shell.CreateShortcut(ShortcutFilePath)
    Result = file.TargetPath
    ShortcutFileLinkPath = Result
End Function

'----------------------------------------
'◆テキストファイル読み書き
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
'◇テキストファイル読込
'エンコード指定は下記の通り
'   エンコード          指定文字
'   ShiftJIS            SHIFT_JIS
'   UTF-16LE BOM有/無   UNICODEFFFE/UNICODE/UTF-16/UTF-16LE
'                       BOMの有無に関わらず読込可能
'   UTF-16BE _BOM_ON    UNICODEFEFF
'   UTF-16BE _BOM_OFF    UTF-16BE
'   UTF-8 BOM有/無      UTF-8/UTF-8N
'                       BOMの有無に関わらず読込可能
'   JIS                 ISO-2022-JP
'   EUC-JP              EUC-JP
'   UTF-7               UTF-7
'UTF-16LEとUTF-8は、BOMの有無にかかわらず読み込める
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
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\SJIS_File.txt", "Shift_JIS"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-7_File.txt", "UTF-7"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-8_File.txt", "UTF-8"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-8_File.txt", "UTF-8N"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-8N_File.txt", "UTF-8N"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-8N_File.txt", "UTF-8"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16BE_BOM_OFF_File.txt", "UTF-16BE"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16BE_BOM_ON_File.txt", "UNICODEFEFF"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16LE"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UNICODE"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_OFF_File.txt", "UNICODEFFFE"))

    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UTF-16"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UTF-16LE"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODE"))
    Call Check("123ABCあいうえお", LoadTextFile("Test\TestLoadTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODEFFFE"))
End Sub

'------------------------------
'◇テキストファイル保存
'エンコード指定は下記の通り
'   エンコード          指定文字
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
'UTF-16LEとUTF-8はそのままだと_BOM_ONになるので
'BON無し指定の場合は特殊処理をしている
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
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\SJIS_File.txt", "Shift_JIS")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-7_File.txt", "UTF-7")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-8_File.txt", "UTF-8")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-8N_File.txt", "UTF-8N")

    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16BE_BOM_OFF_File.txt", "UTF-16BE")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16BE_BOM_ON_File.txt", "UNICODEFEFF")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16LE_BOM_OFF_File.txt", "UTF-16LE")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16LE_BOM_ON1_File.txt", "UNICODEFFFE")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16LE_BOM_ON2_File.txt", "UNICODE")
    Call SaveTextFile("123ABCあいうえお", "Test\TestSaveTextFile\UTF-16LE_BOM_ON3_File.txt", "UTF-16")
End Sub

'----------------------------------------
'◆Iniファイル操作クラス
'----------------------------------------

Class IniFile
    Private IniDic
    Private Path
    Private UpdateFlag

    Private Sub Class_Initialize
        Set IniDic = WScript.CreateObject("Scripting.Dictionary")
        Path = ""
        UpdateFlag = False
    End Sub

    Private Sub Class_Terminate
        Set IniDic = Nothing
    End Sub

    Public Sub Initialize(ByVal IniFilePath)
        Call Assert(fso.FolderExists(fso.GetParentFolderName(IniFilePath)), _
            "Error:IniFile.Initialize:IniFile Folder not found")
        IniDic.RemoveAll
        If fso.FileExists(IniFilePath) Then
            Dim IniFileText
            IniFileText = LoadTextFile(IniFilePath, "SHIFT_JIS")

            Dim IniFileLines: IniFileLines = _
                Split(IniFileText, vbCrLf)
            Dim Section: Section = ""
            Dim Ident: Ident = ""
            Dim I
            For I = 0 To ArrayCount(IniFileLines) - 1
            Do
                Dim Line: Line = Trim(IniFileLines(I))
                If IsFirstStr(Line, "[") And IsLastStr(Line, "]") Then
                    Section = Line
                    Exit Do
                End If
                If Section = "" Then Exit Do
                Ident = FirstStrFirstDelim(Line, "=")
                If Ident <> "" Then
                    Call IniDic.Add(Section+Ident, LastStrFirstDelim(Line, "="))
                End If
            Loop While False
            Next
        End If
        Path = IniFilePath
        UpdateFlag = False
    End Sub

    Private Function DictionaryKey( _
    ByVal Section, ByVal Ident)
        DictionaryKey = IncludeLastStr(IncludeFirstStr(Section, "["), "]") + Ident
    End Function

    Public Function SectionIdentExists( _
    ByVal Section, ByVal Ident)
        SectionIdentExists = _
            IniDic.Exists(DictionaryKey(Section, Ident)) 
    End Function

    Public Function ReadString( _
    ByVal Section, ByVal Ident, ByVal DefaultValue)
        Dim Result
        Dim Key: Key = DictionaryKey(Section, Ident)
        If IniDic.Exists(Key) Then
            Result = IniDic(Key)
        Else
            Result = DefaultValue
        End If
        ReadString = Result
    End Function

    Public Sub WriteString( _
    ByVal Section, ByVal Ident, ByVal Value)
        Dim Key: Key = DictionaryKey(Section, Ident)
        If IniDic.Exists(Key) Then
            IniDic(Key) = Value
        Else
            IniDic.Add Key, Value
        End If
        UpdateFlag = True
    End Sub

    Public Sub Update
        If UpdateFlag = False Then Exit Sub
        'WriteStringを実行したときだけ
        'Updateメソッドが動作する

        Dim IniSectionDic: Set IniSectionDic = WScript.CreateObject("Scripting.Dictionary")
        Dim Keys1: Keys1 = IniDic.Keys

        Dim Section: Section = ""
        Dim I
        For I = 0 To ArrayCount(Keys1) - 1
            Section = FirstStrFirstDelim(Keys1(I), "]") + "]"
            If IniSectionDic.Exists(Section) = False Then
                IniSectionDic.Add Section, ""
            End If
        Next

        Dim IniFileText: IniFileText = ""
        Dim Keys2: Keys2 = IniSectionDic.Keys
        Dim J
        For J = 0 To ArrayCount(Keys2) - 1
            IniFileText = IniFileText + _
                Keys2(J) + vbCrLf
            For I = 0 To ArrayCount(Keys1) - 1
                If IsFirstStr(Keys1(I), Keys2(J)) Then
                    IniFileText = IniFileText + _
                        ExcludeFirstStr(Keys1(I), Keys2(J)) + _
                        "=" + IniDic(Keys1(I)) + vbCrLf 
                End If
            Next 
        Next
        Set IniSectionDic = Nothing

        Call SaveTextFile(IniFileText, Path, "SHIFT_JIS")
    End Sub
End Class

Sub testIniFile
    Dim IniFilePath: IniFilePath = _
        ScriptFolderPath + "\Test\TestIniFile\" + _
        "testIniFile.ini"

    Call ForceCreateFolder(fso.GetParentFolderName(IniFilePath))

    Dim IniFile: Set IniFile = New IniFile
    Call IniFile.Initialize(IniFilePath)

    Call IniFile.WriteString( _
        "Option1", "Test01", "ValueA")
    Call IniFile.WriteString( _
        "Option2", "Test01", "ValueB")
    Call IniFile.WriteString( _
        "Option1", "Test01", "ValueC")

    IniFile.Update

    Call Check("ValueC", IniFile.ReadString("Option1", "Test01", ""))
    Call Check("ValueB", IniFile.ReadString("Option2", "Test01", ""))

    Set IniFile = Nothing
End Sub


'----------------------------------------
'◆システム
'----------------------------------------

'------------------------------
'◇実行時GUI/CUI確認
'------------------------------

Function IsCUI
    IsCui = _
        IsFirstStr(LCase(WScript.FullName), "cscript.exe")
End Function

Function IsGUI
    IsCui = _
        IsFirstStr(LCase(WScript.FullName), "wscript.exe")

End Function


'----------------------------------------
'◆クリップボード
'----------------------------------------

'--------------------
'・テキストデータ取得
'--------------------
Public Function GetClipbordText
    Dim HtmlFile
    Set HtmlFile = WScript.CreateObject("HtmlFile")
    GetClipbordText = HtmlFile.ParentWindow.ClipboardData.GetData("text")
End Function

'--------------------
'・テキストデータ設定
'--------------------
'   ・  IEオブジェクト利用のクリップボード設定方法などは
'       セキュリティの関係で安定して動作しないようなので
'       一時ファイルとClipコマンドを使用した
'--------------------
Public Sub SetClipbordText(ByVal ClipboardToText)
    Dim TempFileName: TempFileName = TemporaryFilePath

    Call SaveTextFile(ClipboardToText, TempFileName, "Shift_JIS")

    Call Shell.Run( _
        "%ComSpec% /c clip < " + _
        InSpacePlusDoubleQuote(TempFileName), _
        0, True)

    Call ForceDeleteFile(TempFileName)
End Sub


'----------------------------------------
'◆シェル
'----------------------------------------

'------------------------------
'◇シェル起動定数
'------------------------------
Const vbHide = 0             'ウィンドウ非表示
Const vbNormalFocus = 1      '通常表示起動
Const vbMinimizedFocus = 2   '最小化起動
Const vbMaximizedFocus = 3   '最大化起動
Const vbNormalNoFocus = 4    '通常表示起動、フォーカスなし
Const vbMinimizedNoFocus = 6 '最小化起動、フォーカスなし

'--------------------
'・ファイル指定したシェル起動
'--------------------
Public Sub ShellFileOpen( _
ByVal FilePath, ByVal Focus)
    Call Assert(OrValue(Focus, Array(0, 1, 2, 3, 4, 6)), "Error:ShellFileOpen")

    Call Shell.Run( _
        "rundll32.exe url.dll" & _
        ",FileProtocolHandler " + FilePath _
        , Focus, False)
    'ファイル起動の場合
    '第三引数のWaitはTrueにしても無視される様子
End Sub

Private Sub testShellFileOpen
    Dim Path: Path = PathCombine(Array( _
            ScriptFolderPath, _
            "Test\TestShellRun\TestShellRun.txt"))
    Call ShellFileOpen(Path, vbNormalFocus)
    Call ShellFileOpen(Path, vbNormalFocus)
End Sub

'--------------------
'・コマンド指定したシェル起動
'   Wait=   Trueならプログラムの終了を待つ
'           Falseならそのまま実行を続ける
'--------------------
Public Sub ShellCommandRun(Command, Focus, Wait)
    Call Assert(OrValue(Focus, Array(0, 1, 2, 3, 4, 6)), "Error:ShellCommandRun")
    Call Assert(OrValue(Wait, Array(True, False)), "Error:ShellCommandRun")

    Call Shell.Run( _
        Command _
        , Focus, Wait)
End Sub

Private Sub testShellCommandRun
    Dim Path: Path = "notepad.exe"
    Call ShellCommandRun(Path, vbNormalFocus, True)
    Call ShellCommandRun(Path, vbNormalFocus, False)
    Call ShellCommandRun(Path, vbNormalFocus, True)
End Sub

'--------------------
'・DOSコマンドの実行。戻り値取得。
'DOS窓が表示されない
'--------------------
Public Function ShellCommandRunReturn(Command, Focus, Wait)
    Call Assert(OrValue(Focus, Array(0, 1, 2, 3, 4, 6)), "Error:ShellCommandRun")
    Call Assert(OrValue(Wait, Array(True, False)), "Error:ShellCommandRun")

    Dim FileName: FileName = TemporaryFilePath

    Call Shell.Run( _
        "%ComSpec% /c " + Command + ">" + FileName + " 2>&1" _
               , Focus, Wait)
    ' 戻り値を取得
    If fso.FileExists(FileName) Then
        ShellCommandRunReturn = _
            LoadTextFile(FileName, "shift_jis")
        Call fso.DeleteFile(FileName)
    End If
End Function

Sub testShellCommandRunReturn()
    MsgBox ShellCommandRunReturn("tree ""C:\Software""", vbHide, True)
    MsgBox ShellCommandRunReturn("dir C:\", vbHide, True)
End Sub

'------------------------------
'◇環境変数の取得
'------------------------------
Public Function EnvironmentalVariables(ByVal Name)
On Error Resume Next
    Dim Result: Result = ""
    Result = Shell.ExpandEnvironmentStrings( _
        IncludeBothEndsStr(Name, "%"))
    EnvironmentalVariables = Result
End Function

Private Sub testEnvironmentalVariables
    MsgBox EnvironmentalVariables("%TEMP%")
    MsgBox EnvironmentalVariables("%username%")
    MsgBox EnvironmentalVariables("appdata")
End Sub

'----------------------------------------
'◆キーコード送信
'----------------------------------------

'------------------------------
'◇指定ウィンドウにキーを送信する
'------------------------------
'・ Shell.AppActivateを実行して成功してから
'   Shell.SendKeysを送信する関数
'・ SearchWindowTitle=""と指定すると
'   Shell.SendKeysだけの処理になる
'・ キーの文字は小文字で指定すること。
'   Ctrl+Cキーを指定しようとして[^C]と
'   大文字で指定するとShiftがロックされて挙動がおかしくなる
'------------------------------
Public Function AppActSendKeysLoop( _
ByVal SearchWindowTitle, _
ByVal KeyValue, ByVal WaitMilliSec, ByVal LoopCount)

    Dim Result: Result = False
    If SearchWindowTitle = "" Then
        Shell.SendKeys KeyValue
        WScript.Sleep WaitMilliSec
        Result = True
    Else
        Dim I
        For I = 1 To LoopCount
            If Shell.AppActivate(SearchWindowTitle, True) Then
                WScript.Sleep 100
                Shell.SendKeys KeyValue
                WScript.Sleep WaitMilliSec
                Result = True
                Exit For
            End If
            WScript.Sleep WaitMilliSec
        Next
    End If
    AppActSendKeysLoop = Result
End Function

Public Function AppActSendKeys( _
ByVal SearchWindowTitle, _
ByVal KeyValue, ByVal WaitMilliSec)
    AppActSendKeys = AppActSendKeysLoop( _
        SearchWindowTitle, _
        KeyValue, WaitMilliSec, 10)
End Function

'------------------------------
'◇指定ウィンドウにキーを送信。
'  その後別ウィンドウがActive化したかどうか確認する関数
'------------------------------
'・ AppActSendKeysLoop後
'   配列で指定したウィンドウタイトルのどれかをアクティブに
'   出来たらTrueを返す関数
'・ 例：    Call AppActSendKeysAfterWindow("test", _
'               Array("WindowA", "WindowB"), "%te", 1000)
'------------------------------
Public Function AppActSendKeysAfterWindowLoop( _
ByVal SearchWindowTitle, ByVal AfterWindowTitle, _
ByVal KeyValue, ByVal WaitMilliSec, ByVal LoopCount)
    Call Assert(IsArray(AfterWindowTitle), _
        "Error:AppActSendKeysAfterWindow:AfterWindowTitle is not Array.")

    Dim Result: Result = False
    Dim I: Dim J

    If AppActSendKeysLoop(SearchWindowTitle, KeyValue, WaitMilliSec, LoopCount) Then
        For J = 0 to ArrayCount(AfterWindowTitle) - 1
            If Shell.AppActivate(AfterWindowTitle(J), True) Then
                Result = True
                Exit For
            End If
        Next
    End If

    AppActSendKeysAfterWindowLoop = Result
End Function

Public Function AppActSendKeysAfterWindow( _
ByVal SearchWindowTitle, ByVal AfterWindowTitle, _
ByVal KeyValue, ByVal WaitMilliSec)
    AppActSendKeysAfterWindow = _
        AppActSendKeysAfterWindowLoop(_
        SearchWindowTitle, AfterWindowTitle, _
        KeyValue, WaitMilliSec, 10)
End Function


'--------------------------------------------------
'■履歴
'◇ ver 2015/01/20
'・ 作成
'・ Assert/Check/OrValue
'・ fso
'・ TestStandardSoftwareLibrary.vbs/Include
'・ LoadTextFile/SaveTextFile
'◇ ver 2015/01/21
'・ FirstStrFirstDelim/FirstStrLastDelim
'   /LastStrFirstDelim/LastStrLastDelim
'◇ ver 2015/01/26
'・ IsFirstStr/IncludeFirstStr/ExcludeFirstStr
'   /IsLastStr/IncludeLastStr/ExcludeLastStr
'◇ ver 2015/01/27
'・ ArrayCount
'・ TrimFirstStrs/TrimLastStrs/TrimBothEndsStrs
'・ StringCombine
'◇ ver 2015/02/02
'・ Shellオブジェクト
'・ CurrentDirectory/ScriptFolderPath
'・ AbsoluteFilePath
'   /IsNetworkPath/GetDrivePath
'   /IsIncludeDrivePath/IncludeLastPathDelim/ExcludeLastPathDelim
'   /PeriodExtName/ExcludePathExt/ChangeFileExt
'   /PathCombine
'・ IIF
'◇ ver 2015/02/04
'・ StringCombine修正
'・ FolderPathListTopFolder/FolderPathListSubFolder
'   /FilePathListTopFolder/FilePathListSubFolder
'・ ForceCreateFolder/ReCreateCopyFolder
'・ ShellFileOpen/ShellCommandRun/ShellCommandRunReturn
'・ EnvironmentalVariables
'・ FormatYYYY_MM_DD/FormatHH_MM_SS
'◇ ver 2015/02/05
'・ ForceDeleteFolder/ReCreateFolder
'・ IniFile読み書きクラス作成
'・ IsCUI/IsGUI
'◇ ver 2015/02/06
'・	ArrayText
'・ LikeCompare/MatchText
'・ ShortcutFileLinkPath
'・ ForceCreateFolder修正
'◇ ver 2015/02/08
'・ ForceCreateFolder/ForceDeleteFolder修正
'・ CopyFolderOverWriteIgnoreFile作成
'◇ ver 2015/02/09
'・ IniFile処理をリファクタリング
'・ MaxValue/MinValue作成
'・ IsLong/LongToStrDigitZero/StrToLongDefault追加
'・ AppActSendKeys/AppActSendKeysAfterWindow等を追加
'◇ ver 2015/02/10
'・ InSpacePlusDoubleQuote修正
'・ ShellCommandRunReturnリファクタリング
'   TemporaryFilePathの作成
'・ GetClipbordText/SetClipbordText作成
'・	ForceDeleteFile作成
'--------------------------------------------------
