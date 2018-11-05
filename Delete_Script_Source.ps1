#Declaring logfile name and path
$Logfile = "C:\delete\DeleteOutput_$(get-date -uformat %d-%b-%y-%H-%M-%S).log" 

#Declare location of the files to be deleted
#Count reset
#Declare files older than days
$path = "C:\delete\delete2"
$count = 0
$days = -60

#A Function allowing us to add output to a file for each LogWrite we use
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

#Get system date
$sysdate = (Get-Date)

#Display system date in log
LogWrite "$sysdate `n"

#Setting the $limit for files older than '$days' days of current date to be deleted
$limit = $sysdate.AddDays($days)

#Setting the $limit2 to a nicely formatted date for reference of when to when the '$days' days of deletion took place
$limit2 = (Get-Date -Format dd-MMM-yyyy)

#Purely for reference
LogWrite "Deleting files that are $days days older than $limit2" 

#If path doesn't exist, stop executing
if (!(Test-Path $path)) {
LogWrite "ERROR: Path '$path' does not exist"
Exit
}

#Find files declared in the $path that is not a folder 
#-Recurse means it will go through the sub folders as well
#!$_.PSIsContainer means do not delete folders (if you want folders deleted, remove the '!')
#Use -LiteralPath for wildcard characters in file names like '[]'
#You can add -and $_.Name -notlike "filename.txt" this will exclude from the get-childitem
$files = Get-ChildItem -LiteralPath $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit }

#Displaying custom text with new lines `n
LogWrite "`nThe following files were found: `n"

#This made the formatting easier on the eyes in the log. Added a new line after each $file
foreach ($file in $files)
{
 LogWrite $file.FullName
}

#Count number of files found
$cnt = $files.Count

#Displaying the total amount of files with $cnt
LogWrite "`nTotal number of files: $cnt"

#Aesthetics
LogWrite "`n ---------------------- `n"

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
    LogWrite $status
    LogWrite $ProcessError
    }

LogWrite "`nTotal number of files deleted successfully: $count of $cnt"
