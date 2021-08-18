using Module ./main.psm1

$ErrorActionPreference_default = $ErrorActionPreference
$ErrorActionPreference = "continue"

$instance = New-Object lotate_mod
$line = "Process Started"
$instance.write_log($line,0)
$trans_log = "$($instance.input_data.logfile)_translog"

Start-Transcript $trans_log 
if($(Test-Path .\param.csv) -eq $False){
    Write-Output("Mode,FileName,DistNation,ExpireDate,option") > .\param.csv
    Write-Output("comp,F:\test.sample*.log,F:\del,7,") >> .\param.csv
    Write-Output("comp,F:\sample\*.log,,7,") >> .\param.csv
    Write-Output("del,F:\sample\del\*.zip,,180,") >> .\param.csv
    return
}

$csv_file = Import-csv "param.csv"
foreach($oneline in $csv_file){
    if((($oneline.FileName.Length -eq 0) -or ($oneline.ExpireDate.Length -eq 0)) -or ($oneline.Mode.Length -eq 0)){
        $line = "Param is not set enough"
        $instance.write_log($line,1)
    }else{
        $parentpath = Split-Path $oneline.FileName -Parent
        $childpath = Split-Path $oneline.FileName -Leaf
        if(($oneline.DistNation -eq $Null) -or ($oneline.DistNation.Length -eq 0)){
            $dist = $parentpath
        }else{
            $dist = $oneline.DistNation
        }
        $filenames = Get-ChildItem $parentpath | Where-Object{$_.Name -like $childpath}
        $filenames| %{
            $today = [DateTime]::ParseExact($(Get-Date -Format "yyyyMMdd") ,"yyyyMMdd", $null)
            $fileDate = [DateTime]::ParseExact($((Get-ChildItem "$parentpath\$_").LastWriteTime.ToString("yyyyMMdd")),"yyyyMMdd", $null)
            $diff_day = ($today - $fileDate).Days
            if($diff_day -gt $oneline.ExpireDate){
                if($oneline.Mode -eq "comp"){
                    $file_name = $_
                    $dist_dir = $dist
                    $option = $oneline.option
                    $instance.compress_file("$parentpath\$file_name",$dist_dir,$option)
                }elseif($_.Mode -eq "del"){
                    $file_name = $_
                    $instance.erase_file("$parentpath\$file_name")
                }
            }else{
                $line = "This file is within the deadline: $($_)"
                $instance.write_log($line,1)
            }
        }
    }
}

$ErrorActionPreference = $ErrorActionPreference_default
Stop-Transcript