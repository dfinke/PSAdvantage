<#
    NOT INTENDED TO BE RUN STAND ALONE !!!

    This is used in the CloneAndGo.ps1
    It is copied and then pushed to the repository, and is run via GitHub Action workflow
#>

./hello.ps1 && ./howdy.ps1

Install-Module importexcel -force

$xlfile = "./data.xlsx"

$data = ConvertFrom-Csv @'
Number,ItemName
1,test1
2,test2
3,test3
4,test4
'@

$data | Export-Excel $xlfile

Import-Excel $xlfile