using System;
using System.DirectoryServices.Protocols;

namespace Check_LDAP_Signing
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args == null || args.Length == 0)
            {
                Console.WriteLine("[-] You have to pass the FQDN as argument");
                return;
            }

            var hostname = args[0];

            bool LDAPSigningEnforced = true;
            bool LDAPSSigningEnforced = true;

            int Port = 389;
            string DN = hostname + ":" + Port;

            LdapConnection c = new LdapConnection(DN);
            c.SessionOptions.Signing = false;
            c.SessionOptions.SecureSocketLayer = false;

            Console.WriteLine("[*] Connecting to " + DN);

            try
            {
                c.Bind();
            }
            catch 
            {
                Console.WriteLine("[-] LDAP not accessible");
            }

            if (!(c.SessionOptions.Signing))
            {
                LDAPSigningEnforced = false;
            }

            Port = 636;
            DN = hostname + ":" + Port;

            LdapConnection d = new LdapConnection(DN);
            d.SessionOptions.Signing = false;
            d.SessionOptions.SecureSocketLayer = true;

            Console.WriteLine("[*] Connecting to " + DN);

            try
            {
                c.Bind();
            }
            catch
            {
                Console.WriteLine("[-] LDAPS not accessible");
            }

            if (!(c.SessionOptions.Signing))
            {
                LDAPSSigningEnforced = false;
            }

            if (LDAPSigningEnforced && !(LDAPSSigningEnforced))
            {
                Console.WriteLine("[+] " + DN + " has LDAP configured in the state 'Negotiate signing', relaying to LDAPS is therefore possible!");
            }
            else if(!(LDAPSigningEnforced) &&!(LDAPSSigningEnforced))
            {
                Console.WriteLine("[+] " + DN + " has LDAP configured in the state 'none', relaying to LDAP and LDAPS is therefore possible!");
            }
            else if(LDAPSigningEnforced && LDAPSSigningEnforced)
            {
                Console.WriteLine("[-] " + DN + " has LDAP configured in the state 'Require Signing', relaying is not possible!");
            }
            else if(!(LDAPSigningEnforced) && LDAPSSigningEnforced)
            {
                Console.WriteLine("[+] " + DN + " has LDAP configured in the state 'none' or 'Negotiate signing' without LDAPS in use, relaying to LDAP is possible!");
            }
        }
    }
}
