$x=Get-ChildItem -directory -Name -Exclude .*
$absPath="C:\github-repos\tf_az_base_modules\"
foreach ($i in $x)
{
    set-location $absPath$i
    Write-Output "Running terraform fmt in $absPath$i"
    terraform fmt
    set-location ..
    
}