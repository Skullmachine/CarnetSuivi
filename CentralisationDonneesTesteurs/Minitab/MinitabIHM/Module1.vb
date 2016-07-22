Imports System.IO
Imports System.Data.SqlClient
Imports System.Text.RegularExpressions

Module Module1

    Sub Main()

        Dim MtbApp As New Mtb.Application
        Dim MtbProj As Mtb.Project
        Dim MtbOutDoc As Mtb.OutputDocument

        Dim stationId As String = "SMEG04@MMCHT"
        Dim startDateTime As String = "20160512"
        Dim endDateTime As String = "20160515"
        Dim stepName As String
        Dim uutSerialNumber As String = "1Z+"
        Dim lowLimit, highLimit As String
        Dim loopNumber As Integer = 0
        Dim myStepNames As List(Of String())
        Dim quitApplication As Boolean

        'Retrieve step names from one reference of a product from one tester
        myStepNames = ConnectToSQL(stationId, startDateTime, endDateTime, uutSerialNumber)

        For i As Integer = 0 To myStepNames.Count - 1
            If (loopNumber > 98) Then
                loopNumber = 0
                quitApplication = True
            Else
                quitApplication = False
            End If
            If (i = (myStepNames.Count - 1)) Then

            End If

            Console.WriteLine(myStepNames(i)(0))
            stepName = myStepNames(i)(0)
            highLimit = myStepNames(i)(1)
            lowLimit = myStepNames(i)(2)
            BuildSQLQuery(stationId, startDateTime, endDateTime, stepName, uutSerialNumber)
            BuildMinitabQuery(MtbProj, MtbApp, uutSerialNumber, stationId, stepName, lowLimit, highLimit, quitapplication)
            loopNumber = loopNumber + 1
            OutputHTML(MtbProj, MtbApp, MtbOutDoc, quitApplication, stationId, uutSerialNumber, stepName)
        Next
    End Sub

    'Return step names from one reference of a product from one tester
    Public Function ConnectToSQL(myStationId As String, myStartDateTime As String, myEndDateTime As String, myUutSerialNumber As String) As List(Of String())
        Dim myConnectionString As New SqlConnection
        Dim myReader As SqlDataReader
        Dim myStepNames As New List(Of String())
        Dim myQuery As String = "SELECT DISTINCT LTRIM(RTRIM(STEP_NAME)), HIGH_LIMIT, LOW_LIMIT FROM dbo.FACT_MEASURE WHERE UUT_SERIAL_NUMBER like '" + myUutSerialNumber + "%' AND START_DATE_TIME >= '" + myStartDateTime + "' AND START_DATE_TIME < '" + myEndDateTime + "' AND STATION_ID like '" + myStationId + "%' AND STEP_TYPE like 'NumericLimitTest%' AND STATUS not like 'Skipped%' AND (HIGH_LIMIT IS NOT NULL OR LOW_LIMIT IS NOT NULL)"

        'Try to connect to the database
        Try
            myConnectionString.ConnectionString = "Data Source=172.16.52.123;Initial Catalog=DMCapabiliteRetest;Persist Security Info=True;User ID=mces02;Password=mmf086+"
            Dim mySqlCommand As New SqlCommand(myQuery, myConnectionString)
            myConnectionString.Open()
            Console.WriteLine("Connection opened")
            Console.WriteLine("Connection String:" + myQuery)
            'Execute Query
            myReader = mySqlCommand.ExecuteReader()
            While myReader.Read()
                myStepNames.Add({myReader(0).ToString, myReader(1).ToString, myReader(2).ToString})
                Console.WriteLine(String.Format("{0}, {1}, {2}", myReader(0), myReader(1), myReader(2)))
            End While
        Catch ex As Exception
            Console.WriteLine("Error while connecting to SQL Server. " & ex.Message)
        Finally
            myConnectionString.Close()
            Console.WriteLine("Connection closed")
        End Try
        Return myStepNames
    End Function

    'Build SQL query for Minitab Session 
    Sub BuildSQLQuery(stationId As String, startDateTime As String, endDateTime As String, stepName As String, uutSerialNumber As String)
        Dim fileToAppend As String = "d:\users\F85601A\Desktop\Minitab\MinitabIHM\Resources\ExecODBC.mtb"
        File.WriteAllText(fileToAppend, "")

        Dim inputs() As String = {"ODBC;", _
                                  "Connect ""DSN=Server Rapports Test;UID=mces02;PWD=mmf086+;APP=Minitab 17 Statistical Software;WSID=DT0102395;DATABASE=DMCapabiliteRetest;"";", _
                                  "SQLString ""SELECT """"STEP_NAME"""", """"UUT_SERIAL_NUMBER"""", "" &", _
                                  """""""START_DATE_TIME"""", COALESCE(""""HIGH_LIMIT"""",0) AS HIGH_LIMIT, "" & ", _
                                  """TRY_CONVERT(FLOAT,""""DATA"""") AS DATA, COALESCE(""""LOW_LIMIT"""",0) AS LOW_LIMIT, "" &", _
                                  """""""STATUS"""", """"TOTAL_TIME"""", """"COMP_OPERATOR"""" "" & ", _
                                  """FROM """"DMCapabiliteRetest"""".""""dbo"""".""""FACT_MEASURE"""" WITH (READUNCOMMITTED)  "" &", _
                                  """WHERE """"STATION_ID"""" LIKE '" + stationId + "%' "" &", _
                                  """AND """"START_DATE_TIME"""" >= '" + startDateTime + "' "" &", _
                                  """AND """"START_DATE_TIME"""" <= '" + endDateTime + "' "" &", _
                                  """AND LTRIM(RTRIM(""""STEP_NAME"""")) = '" + stepName + "' "" &", _
                                  """AND """"STEP_TYPE"""" like 'NumericLimitTest%' "" &", _
                                  """AND """"STATUS"""" not like 'Skipped%' "" &", _
                                  """AND """"UUT_SERIAL_NUMBER"""" like '" + uutSerialNumber + "%'"". "}
        'Append ExecODBC
        AppendFile(inputs, fileToAppend)

    End Sub

    Sub BuildMinitabQuery(MtbProj As Mtb.Project, MtbApp As Mtb.Application, uutSerialnumber As String, stationId As String, stepName As String, highLimit As String, lowLimit As String, quitApplication As Boolean)

        'MtbApp.UserInterface.Visible = True

        Dim fileToAppend As String = "d:\users\F85601A\Desktop\Minitab\MinitabIHM\Resources\ExecCapa.mtb"
        File.WriteAllText(fileToAppend, "")
        Dim inputs() As String

        If (highLimit Like "" Or lowLimit Like "") Then
            If highLimit Like "" Then
                inputs = {"Capa 'DATA' 1;",
                                 "Uspec " + lowLimit + ";", _
                                 "Pooled;", _
                                 "AMR;", _
                                 "UnBiased;", _
                                 "OBiased;", _
                                 "Toler 6;", _
                                 "Within;", _
                                 "Overall;", _
                                 "Title """ + stepName + """;", _
                                 "CStat."}
            Else
                inputs = {"Capa 'DATA' 1;",
                                 "Lspec " + highLimit + ";", _
                                 "Pooled;", _
                                 "AMR;", _
                                 "UnBiased;", _
                                 "OBiased;", _
                                 "Toler 6;", _
                                 "Within;", _
                                 "Overall;", _
                                 "Title """ + stepName + """;", _
                                 "CStat."}
            End If
        Else
            inputs = {"Capa 'DATA' 1;",
                        "Lspec " + highLimit + ";", _
                        "Uspec " + lowLimit + ";", _
                        "Pooled;", _
                        "AMR;", _
                        "UnBiased;", _
                        "OBiased;", _
                        "Toler 6;", _
                        "Within;", _
                        "Overall;", _
                        "Title """ + stepName + """;", _
                        "CStat."}
        End If

        'Append ExecCapa.mtb
        AppendFile(inputs, fileToAppend)

        Try
            MtbProj = MtbApp.ActiveProject
            With MtbProj
                .ExecuteCommand("Execute 'd:\users\F85601A\Desktop\Minitab\MinitabIHM\Resources\ExecODBC.mtb' 1.")
                .ExecuteCommand("Execute 'd:\users\F85601A\Desktop\Minitab\MinitabIHM\Resources\ExecCapa.mtb' 1.")
            End With
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub

    'Append file
    Sub AppendFile(inputs() As String, fileToAppend As String)
        Dim lstOfString As List(Of String) = New List(Of String)(inputs)
        Dim fileExists As Boolean = File.Exists(fileToAppend)
        Using sw As New StreamWriter(File.Open(fileToAppend, FileMode.OpenOrCreate))
            If fileExists Then
                For Each line As String In lstOfString
                    sw.WriteLine(line)
                Next
            End If
        End Using
    End Sub

    Public Sub OutputHTML(MtbProj As Mtb.Project, MtbApp As Mtb.Application, MtbOutDoc As Mtb.OutputDocument, quitApplication As Boolean, stationId As String, uutSerialNumber As String, stepName As String)

        Dim cleanPath As String = Regex.Replace(stepName, "[ ](?=[ ])|[^-_,A-Za-z0-9 ]+", "")

        MtbOutDoc = MtbProj.Commands.OutputDocument
        If (quitApplication = True) Then
            With MtbOutDoc
                .OutputWidth = 50
                .SaveAs("D:\" + stationId + "\" + uutSerialNumber + "\" + cleanPath, True, 1)
            End With
            MtbApp.Quit()
            MtbApp.New()
        End If
    End Sub

End Module
