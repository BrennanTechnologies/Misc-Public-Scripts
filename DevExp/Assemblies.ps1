[System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {$_.Location} | %{ Split-Path -Leaf $_.Location}