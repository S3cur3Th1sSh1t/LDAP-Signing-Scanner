Function Check-LDAP-Signing
{

param(
[string]
$FQDN
)


    [System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols")
    
    Write-Verbose "`nTesting LDAP without signing"
    
    $LDAPSigningEnforced = $true
    $LDAPSSigningEnforced = $true

    $ServerName = $FQDN
    $Port = 389
    $dn = "$ServerName"+":"+"$Port"
    $c = New-Object System.DirectoryServices.Protocols.LdapConnection $dn
    $c.SessionOptions.Signing =$false
    $c.SessionOptions.SecureSocketLayer = $false
    
    
    # Simple Bind
    Write-Verbose "`nBinding connection to DC...`n"
    
    try
    {
        $c.Bind()
    }catch{Write-Verbose "`nLDAP not accessible`n"}
    
    if (!($c.SessionOptions.Signing))
    {
        $LDAPSigningEnforced = $false
    }
    
    Write-Verbose "`n`n`nTesting LDAPS without signing"
    $Port = 636
    $dn = "$ServerName"+":"+"$Port"
    $c = New-Object System.DirectoryServices.Protocols.LdapConnection $dn
    $c.SessionOptions.Signing =$false
    $c.SessionOptions.SecureSocketLayer = $true

    
    # Simple Bind
    Write-Verbose "`nBinding connection to DC...`n"
    
    try
    {
        $c.Bind()
    }catch{Write-Verbose "`nLDAPS not accessible`n"}
    
 
    if (!($c.SessionOptions.Signing))
    {
        $LDAPSSigningEnforced = $false
    }

    if($LDAPSigningEnforced -and !($LDAPSSigningEnforced))
    {
        Write-Host $ServerName + " has LDAP configured in the state 'Negotiate signing', relaying to LDAPS is therefore possible!"
    }
    elseif(!($LDAPSigningEnforced) -and !($LDAPSSigningEnforced))
    {
        Write-Host $ServerName + " has LDAP configured in the state 'none', relaying to LDAP and LDAPS is therefore possible!"
    }
    elseif($LDAPSigningEnforced -and $LDAPSSigningEnforced)
    {
        Write-Host $ServerName + " has LDAP configured in the state 'Require Signing', relaying is not possible!"
    }
    elseif(!($LDAPSigningEnforced) -and $LDAPSSigningEnforced)
    {
        Write-Host $ServerName + " has LDAP configured in the state 'none' or 'Negotiate signing' without LDAPS in use, relaying to LDAP is possible!"
    }

}
