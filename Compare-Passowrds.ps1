<#
.SYNOPSIS
Compares a new password to the older password to verify they are not similiar.

.DESCRIPTION
Converts secure passwords to plain text and performs a match comparison on the 

.PARAMETER Previous_Password
The previous password used in comparison with $New_Password.
    - Requires a secure string [Security.SecureString]

.PARAMETER New_Password
The new password to compare against $Previous_Password. 
    - Requires a secure string [Security.SecureString]

.PARAMETER CompareLength
Length of the compare string to create an use. (Default  3)

.EXAMPLE
Example 1:
    Check-Password-Against-Previous-Password -Previous_Password $Previous_Password -New_Password $New_Password

Example 2: 
    Check-Password-Against-Previous-Password -Previous_Password $Previous_Password -New_Password $New_Password -CompareLength 4

Example 3:
    if (Check-Password-Against-Previous-Password -Previous_Password $Previous_Password -New_Password $New_Password -CompareLength 3 ) {
        Write-Host "Success!" -ForegroundColor Green
    } else {
        Write-Host "Failure!" -ForegroundColor Red
    }

.NOTES

#>
Function Check-Password-Against-Previous-Password {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Security.SecureString]$Previous_Password,
        [Parameter(Mandatory = $true)]
        [Security.SecureString]$New_Password,
        [Parameter(Mandatory = $false)]
        [int]$CompareLength = 3
    )

    Begin {
        # Convert password from System.Security.SecureString to PlainText
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Previous_Password)
        [string]$Plain_Previous_Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # Convert password from System.Security.SecureString to PlainText
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($New_Password)
        [string]$Plain_New_Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # Set the Counter for the number of Matches found.
        [int]$MatchCount = 0 # Count of matches found in -match comparioson.
    }
    Process {
        for ( $i = 0; $i -le $Previous_Password.Length; $i++ ) {
            
            # Create character combo strings from $Previous_Password: (start at 0.. $CompareLength).
            [string]$Previous_Password_String = [char[]]$Plain_Previous_Password[ $i.. ($i + ($CompareLength - 1)) ] -join ''

            if ($Previous_Password_String.Length -eq $CompareLength) {
                $Previous_Password_Combo = $Previous_Password_String
            }

            # Increment the starting location of the next combo string.
            $i = $i + ($CompareLength - 1)

            # Compare the Combo string to the $New_Password
            if ( [bool]( $Plain_New_Password -match $Previous_Password_Combo) ) {
                # Increment the counter if a match is found.
                $MatchCount++
            }
        }
    }
    End {
        if ( $MATCHCOUNT -gt 0 ) {
            Write-Host "Previous_Pass_Combo found in New_Password:" $Previous_Password_Combo -ForegroundColor DarkRed
            return $false
        }
        else { 
            Write-Host "Passwords are not similiar." -ForegroundColor DarkGreen
            return $true 
        }
    }
}

# Test the function, and get the retuen value
cls
$Previous_Password = Read-Host -AsSecureString "Enter Previous_Password" 
$New_Password = Read-Host -AsSecureString "Enter New_Password" 

if (Check-Password-Against-Previous-Password -Previous_Password $Previous_Password -New_Password $New_Password -CompareLength 4 ) {
    Write-Host "Success!" -ForegroundColor Green
} else {
    Write-Host "Failure!" -ForegroundColor Red
}