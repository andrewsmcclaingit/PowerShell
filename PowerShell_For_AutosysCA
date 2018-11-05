#Variables from a local file 
& ((Split-Path $MyInvocation.InvocationName) + "\..\localfilename.ps1")

#sets the default CWD  
#sets the default AutoSys log folder
#Declare location of the files to be deleted
#Count reset
#Declare files older than days (dont forget '-' to make negative)
#Get current date
#New line for good looks
#Setting the $limit for files older than '$days' days of current date to be deleted
#Exit code reset
$cwd =$Env:CWD
$logFolder= $Env:LOG_FOLDER
$path = "putyourpathhere"
$count = 0
$days = -60
$currentDate = Get-Date
$newLine = "`r`n"
$limit = $currentDate.AddDays($days)
$exitcode = 0

write-output "`r`n----------------------------------------------------------------------------------------------"
write-output "Delete Job"
write-output "Get everything that is older than $currentDate - 60 days $newLine"
write-output "Starting Delete"	

#If path doesn't exist, stop executing
if (!(Test-Path $path)) {
$exitcode = 1
write-output "ERROR: Path '$path' does not exist"
write-output "`r`n**** Reaching the end of running PS utility script"
write-output "exitcode before is Prod = $exitcode "  
exit $exitcode
}

#Find files declared in the $path that is not a folder 
#-Recurse means it will go through the sub folders as well
#!$_.PSIsContainer means do not delete folders (if you want folders deleted, remove the '!')
#Use -LiteralPath for wildcard characters in file names like '[]'
#$_.Name -notlike means I am excluding files called trigger.txt
$files = Get-ChildItem -LiteralPath $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit -and $_.Name -notlike "trigger.txt" }

#Displaying custom text with new lines `n
write-output "`r`nThe following files were found: `n"

#This made the formatting easier on the eyes in the log. Added a new line after each $file
foreach ($file in $files)
{
 write-output $file.FullName
}

#Count number of files found
$cnt = $files.Count

#Displaying the total amount of files with $cnt
write-output "`nTotal number of files: $cnt"

#Aesthetics
write-output "----------------------------------------------------------------------------------------------"

#Delete files one at a time and test that they were successfully deleted.
#Use -LiteralPath for wildcard characters in file names like '[]'

foreach ($file in $files)
{
    Remove-Item -LiteralPath $file.FullName -Force -ErrorAction SilentlyContinue -ErrorVariable ProcessError 

    #Test whether file has been deleted and write to log
    if (!(Get-ChildItem -LiteralPath $file.FullName -ErrorAction SilentlyContinue))
    {
		$count++
        $status = "Deletion for $($file.FullName) SUCCESS"   
    }
    elseif ($ProcessError)
    {
        $status = "Deletion for $($file.FullName) FAILED" 
    }
    #Write status and/or error (i.e. file locked) to logfile
    write-output $status
    write-output $ProcessError
    }

write-output "`r`nTotal number of files deleted successfully: $count of $cnt"

exit $exitcode 
