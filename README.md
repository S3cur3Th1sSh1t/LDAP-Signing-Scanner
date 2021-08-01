# LDAP-Signing-Scanner
A little scanner to check the LDAP Signing state.

The idea is to connect to a DC via LDAP and LDAPS with signing set to false from the client side. The DC can either force signing and ignore the client request or accept it to not use signing.

https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/network-security-ldap-client-signing-requirements

The results from both connections tell us which option is in use:

| LDAP result   | LDAPS result  | Option in use |
| ------------- | ------------- | ------------- |
| Signing enforced  | Signing not enforced  | Negotiate signing |
| Signing not enforced  | Signing not enforced  | none |
| Signing enforced  | Signing enforced  | Require signing |
| Signing not enforced  | LDAPS not available  | none or Negotiate signing |