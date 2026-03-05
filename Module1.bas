Attribute VB_Name = "Module1"
' ***************************************************************
' Project: Hospital ER Efficiency Auditor
' Purpose: Analyzes patient wait times and satisfaction scores
'          to identify critical service delays.
' ***************************************************************

Sub AuditEREfficiency()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    Dim waitTime As Double
    Dim satisfaction As Double
    Dim criticalCount As Integer
    
    Set ws = ThisWorkbook.Sheets(1) ' Focuses on your patient data
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    criticalCount = 0
    
    ' Loop starts at Row 2 (skipping the header)
    For i = 2 To lastRow
        ' Column K (11) is Patient Waittime
        ' Column J (10) is Patient Satisfaction Score
        waitTime = ws.Cells(i, 11).Value
        satisfaction = ws.Cells(i, 10).Value
        
        ' Logic: Flag if Wait Time is over 45 mins OR Satisfaction is very low (below 3)
        If waitTime > 45 Or (satisfaction < 3 And satisfaction > 0) Then
            ' Highlight these critical rows in a sophisticated Soft Coral
            ws.Range(ws.Cells(i, 1), ws.Cells(i, 12)).Interior.Color = RGB(255, 204, 203)
            criticalCount = criticalCount + 1
        Else
            ' Keep standard rows clean
            ws.Range(ws.Cells(i, 1), ws.Cells(i, 12)).Interior.ColorIndex = xlNone
        End If
    Next i
    
    ' Professional Summary
    MsgBox "ER Audit Complete. " & criticalCount & " patients identified with efficiency alerts.", vbExclamation, "ER Operations"
End Sub
