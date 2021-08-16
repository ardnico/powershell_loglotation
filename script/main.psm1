
function putLog([String]$line,$code){
    if($code -eq 0){
        $code = ""
    }elseif($code -eq 1){
        $code = "war"
    }elseif($code -eq -1){
        $code = "err"
    }
    $key = "$(Get-Date -Format "[yyyy/MM/dd hh:mm:ss]") $line"
    Write-Host($key)
    Write-Output($key)
    return $key
}

class lotate_mod{
    [System.Object]$global:input_data = @{}

    function set_param($keyword,$param){
        $this.input_data.Add($keyname,$param)
    }

    function file_lock_chk($filename){
        try{
            # initialise variables
            $script:filelocked = $false

            # attempt to open file and detect file lock
            $script:fileInfo = New-Object System.IO.FileInfo $Path
            $script:fileStream = $fileInfo.Open([System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)

            # close stream if not lock
            if ($fileStream)
            {
                $fileStream.Close()
            }
            return 0
        }catch{
            # catch fileStream had falied
            $filelocked = $true
            return 1
        }
    }

    function compress_file($file_name,$dist_dir,$option){
        if($option.Length -gt 0){
            $line = "Option exists: $option"
            write_log($line,0)
        }
        $file_test = $this.file_lock_chk($file_name)
        if($file_test -eq 1){
            $line = "This file is locked : $file_name"
            write_log($line,1)
        }else{
            try{
                .\7z.exe a "$dist_dir$(Split-Path $file_name -Leaf).zip" $file_name $option
                # Directory判定
                if((Get-Item $file_name).PSIsContainer -eq $True){
                    Remove-Item $file_name -Force -Recurse
                }else{
                    Remove-Item $file_name -Force
                }
            }catch{
                $line = "This action failed: 7z.exe a ""$dist_dir$(Split-Path $file_name -Leaf).zip"" $file_name $option"
                write_log($line,-1)
            }
        }
    }

    function erase_file($file_name){
        $file_test = $this.file_lock_chk($file_name)
        if($file_test -eq 1){
            $line = "This file is locked : $file_name"
            write_log($line,1)
        }else{
            if((Get-Item $file_name).PSIsContainer -eq $True){
            }else{
                try{
                    # Directory判定
                    if((Get-Item $file_name).PSIsContainer -eq $True){
                        Remove-Item $file_name -Force -Recurse
                    }else{
                        Remove-Item $file_name -Force
                    }
                }catch{
                    $line = "Failed to remove : $file_namw"
                    write_log($line,-1)
                }
            }
        }
    }
    function write_log($line,$code){
        if($this.input_data.logfile.Length -eq 0){
            $CurrentDir = "$(Split-Path $MyInvocation.MyCommand.Path)\log"
            New-Item $CurrentDir -ItemType Directory -Force
            $this.input_data.logfile = "$CurrentDir\lotation_$(Get-Date -Format 'yyyymmdd').log"
        }
        putLog([String]$line,$code)
    }

}