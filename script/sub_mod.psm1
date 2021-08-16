
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

class sub_mod{
    [System.Object]$global:input_data = @{}

    function set_param($keyword,$param){
        $this.input_data.Add($keyname,$param)
    }

    function chk_param(){

    }

    
}