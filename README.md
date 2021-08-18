# PowerBI-UnitTest-automation
This PowerShell script is to automate the unit testing process.
You can specify the file paths in the below variables
![image](https://user-images.githubusercontent.com/74527901/129902945-6ff5273e-9c27-4623-bc1a-420600e76063.png)

$filterFilePath, $defaultTestData, $outFilePath.

You also need to update the filterCondition.txt file. This condition will be applied while executing the each measures.
![image](https://user-images.githubusercontent.com/74527901/129903455-393f45f4-f4c0-4147-805c-689b1b0661c1.png)

The UnitTest.xlsx file is expected to keep the measure names and its output.

![image](https://user-images.githubusercontent.com/74527901/129903689-62b3161f-b426-4f1a-a22c-1d18b47eb0cd.png)

When you run this script make sure your pbix file is running in your local machine.
Sample output will be look like the below snapshot
![image](https://user-images.githubusercontent.com/74527901/129904079-8f81b312-e9a8-447f-bd1a-126e7f3ee608.png)


References
1. https://kohera.be/sql-server/use-powershell-get-measures-2016-tabular-cube-open-power-bi-desktop-file/
2. https://tsql.tech/quick-tip-how-to-find-the-address-of-the-powerbi-local-tabular-instance/
3. https://gist.github.com/janegilring/ada89d75ceb8cc558cd9738873c4b36b
4. https://docs.microsoft.com/en-us/powershell/module/sqlserver/invoke-ascmd?view=sqlserver-ps
