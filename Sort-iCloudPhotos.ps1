param([string]$Dir)
$Dir = Get-Item $Dir
Set-Location $Dir
$hash = @{}

foreach ($Photo in (Get-ChildItem $Dir)) {
    $CTime = (Get-Item $Photo).CreationTimeUtc
    $TimeStr = $CTime.ToString('yyyyMMdd_HHmmssfff')
    
    $NewName = $TimeStr + '_iOS' + $Photo.Extension
    if ($hash.ContainsKey($NewName)) {
        $hash[$NewName] += 1
        $NewName = $TimeStr + ($hash[$NewName] - 1) + '_iOS' + $Photo.Extension
    }
    else {
        $hash.Add($NewName, 1)
    }
    
    Rename-Item $Photo $NewName
    $Location = "$($CTime.ToString('yyyy'))`/$($CTime.ToString('MM'))"
    mkdir -f -p $Location | Out-Null
    Move-Item "$($NewName)" $Location
}
