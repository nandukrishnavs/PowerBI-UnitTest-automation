# PowerBI-UnitTest-automation
This PowerShell script is to automate the Power BI DAX unit testing process.

***To execute this script, you have to install sqlserver module. (Run as admin)***

```Install-Module sqlserver -allowclobber```

![image](https://user-images.githubusercontent.com/74527901/130020380-71c8f897-3463-497d-9de8-24b4bb5824df.png)

Next, You have to modify the **PowerBI_UnitTest.ps1** file. You can specify the file paths in the below variables
![image](https://user-images.githubusercontent.com/74527901/129902945-6ff5273e-9c27-4623-bc1a-420600e76063.png)

```$filterFilePath, $defaultTestData, $outFilePath.```

Also you need to update the **filterCondition.txt** file. This condition will be applied while executing each measure. 
![image](https://user-images.githubusercontent.com/74527901/129903455-393f45f4-f4c0-4147-805c-689b1b0661c1.png)

The **UnitTest.xlsx** file is expected to keep the measure names and its output.

![image](https://user-images.githubusercontent.com/74527901/129903689-62b3161f-b426-4f1a-a22c-1d18b47eb0cd.png)

***When you run this script make sure your pbix file is running in your local machine.*** 

###### Now you are ready to run ######
Once you run the script, you will get a popup box. You can choose 

1. Yes - Execute all the measures available in the model

2. No - Execute all the measures listed in the UnitTest.xlsx file

3. Quit - cancel the execution


![image](https://user-images.githubusercontent.com/74527901/130042195-8ddb623d-af4a-49b6-acf4-1e3e820e9ae4.png)

Sample output will be look like the below snapshot

![image](https://user-images.githubusercontent.com/74527901/130042344-41b0ccc6-c8c2-4b01-a517-bed2c99ecf0c.png)



## References
1. https://kohera.be/sql-server/use-powershell-get-measures-2016-tabular-cube-open-power-bi-desktop-file/
2. https://tsql.tech/quick-tip-how-to-find-the-address-of-the-powerbi-local-tabular-instance/
3. https://gist.github.com/janegilring/ada89d75ceb8cc558cd9738873c4b36b
4. https://docs.microsoft.com/en-us/powershell/module/sqlserver/invoke-ascmd?view=sqlserver-ps
5. https://social.technet.microsoft.com/wiki/contents/articles/24030.powershell-demo-prompt-for-choice.aspx
