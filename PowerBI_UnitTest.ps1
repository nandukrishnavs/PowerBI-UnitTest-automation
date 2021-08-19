[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Tabular");
cls

#Update these variables

#file which contains custom filter condition
$filterFilePath="C:\Mytest\filterCondition.txt"

#file which contains test data
$defaultTestData="C:\Mytest\UnitTest.xlsx"

#To save the log 
$outFilePath="C:\Mytest\out.txt "

#Reading the filter query
$customFilterQuery = [IO.File]::ReadAllText($filterFilePath)

#To get the Power BI local instance server address and port number
function getServer()
{
    $powerbiprocess = Get-Process -ProcessName msmdsrv

    if ($null -eq $powerbiprocess) 
        {
            Write-Host "A PowerBi model instance is not running"
        }
    else 
        {
            $a = Get-NetTCPConnection -OwningProcess $powerbiprocess.Id
            $port = $a[0].LocalPort
            $server="localhost:$port"
            Write-Host "The PowerBi local SSAS instance is @ localhost:$port"
        }

return "localhost:$port"
}


#To get the Power BI local database Id
function getDatabaseId()
{
    

    $db = $as.Databases.ID;
    write-host "`nDatabase Id :$db`n"
    return $db
}

$unitTestArray = @()
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $outFilePath
#Reading the server name
$file = Read-Host -Prompt "Please enter input excel path. `nExample: C:\Mytest\UnitTest.xlsx`n"

    if ([string]::IsNullOrWhiteSpace($file))
        {
            #Dafault path
            $file = $defaultTestData

        }

    $sheetName = "Measures"

    #create new excel COM object
    $excel = New-Object -com Excel.Application

    #open excel file
    $wb = $excel.workbooks.open($file)

    #select excel sheet to read data
    $sheet = $wb.Worksheets.Item($sheetname)

    #calculate the row count
    $rowMax = ($sheet.UsedRange.Rows).Count

    #create new object with Name, Output properties.
    $myData = New-Object -TypeName psobject
    $myData | Add-Member -MemberType NoteProperty -Name Name -Value $null
    $myData | Add-Member -MemberType NoteProperty -Name Output -Value $null


    #create empty arraylist
    for ($i = 2; $i -le $rowMax; $i++)
        {
            $objTemp = $myData | Select-Object *
            #read data from each cell
            $objTemp.Name = $sheet.Cells.Item($i,1).Text
            $objTemp.Output = $sheet.Cells.Item($i,2).Text
            $unitTestArray += $objTemp
        }
    Write-Host "`n`nInput Data`n"
    $unitTestArray



Write-Host "`n`n=======================================================================================`n"


#connecting to the local Power BI instance
$as = New-Object Microsoft.AnalysisServices.Tabular.Server;
$server = getServer;
$as.Connect($server);
$dbId=getDatabaseId
$db = $as.Databases[$dbId]


Write-Host "`n`n=======================================================================================`n"


$out = "";
$passedCount=0;
$failedCount=0;
$missingCount=0;

#Traversing through each measures
foreach($table in $db.Model.Tables) 
    {
    foreach($measure in $table.Measures) 
        {
            $measureName=$measure.Name
            $customQuery="CALCULATE([$measureName]$customFilterQuery)"
            $exp =$measure.Expression
            $out = $measure.Name + ":=" + $exp + "`n";
            Write-Host "$out `nCustom Query:=$customQuery`n" ;
            #Executing the custom Query
            [xml]$Data = Invoke-ASCmd -Query "EVALUATE ({$customQuery})" -Server $server  -Database $dbId;
            #Geting the result
            $Result=$Data.return.root.row._x005B_Value_x005D_;
            $FilteredArray = $unitTestArray.Where({$_.Name -EQ $measure.Name}); 
            $Expectedresult= $FilteredArray.Output

            Write-Host "Result`n$Result`n`nExpected Result`n$Expectedresult`n" 
            if([string]::IsNullOrEmpty($Expectedresult))
                {
                     Write-Host "Test case missing`n" -ForegroundColor Gray;
                     $missingCount+=1
                }
            else
                {
                           
                if($Result -eq $Expectedresult)
                    {
                        Write-Host "Test case passed`n" -ForegroundColor Green;
                        $passedCount +=1;
                    }
                else 
                     {
                        Write-Host "Test case failed`n" -ForegroundColor Red;
                        $failedCount +=1;
                     }

                }
    
    Write-Host "=======================================================================================`n" -ForegroundColor yellow
  }
}

Write-Host "Passed  :$passedCount`nFailed  :$failedCount`nMissing :$missingCount`n"


$as.Disconnect();
$excel.Quit()

Write-Host "`n=======================================================================================`n" -ForegroundColor yellow

Read-Host -Prompt “Press Enter to exit”

Stop-Transcript
