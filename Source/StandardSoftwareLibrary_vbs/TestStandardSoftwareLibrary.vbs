'--------------------------------------------------
'Standard Software Library For Windows VBScript
'
'ModuleName:    TestStandardSoftwareLibrary.vbs
'--------------------------------------------------
'version        2015/01/21
'--------------------------------------------------
Option Explicit

'--------------------------------------------------
'��Include Standard Software Library
'--------------------------------------------------
'FileName�ɂ͑��΃A�h���X���w��\
'--------------------------------------------------
'Call Include(".\Test\..\..\StandardSoftwareLibrary_vbs\StandardSoftwareLibrary.vbs")
Call Include(".\StandardSoftwareLibrary.vbs")

Sub Include(ByVal FileName)
    Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject") 
    Dim Stream: Set Stream = fso.OpenTextFile( _
        fso.GetParentFolderName(WScript.ScriptFullName) _
        + "\" + FileName, 1)
    ExecuteGlobal Stream.ReadAll() 
    Call Stream.Close
End Sub
'--------------------------------------------------

Call test

