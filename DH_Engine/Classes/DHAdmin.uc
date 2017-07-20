//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAdmin extends AdminIni;

// From the Admin class (which the AdminIni class does not extend), to attempt a silent admin login
// AdminIni, as normally used in RO, did not implement this & only inherited the empty function from the AdminBase class, meaning silent logins would not work
function DoLoginSilent(string Username, string Password)
{
    if (Level.Game != none && Level.Game.AccessControl != none && Level.Game.AccessControl.AdminLoginSilent(Outer, Username, Password))
    {
        bAdmin = true;
        Outer.ReceiveLocalizedMessage(Level.Game.GameMessageClass, 20);
    }
}

// Modified to handle silent admin logout (incorporating the silent admin functionality from Admin class into the parent AdminIni class function)
function DoLogout()
{
    local bool bWasSilent;

    bWasSilent = Outer.PlayerReplicationInfo != none && Outer.PlayerReplicationInfo.bSilentAdmin;

    if (xManager.AdminLogout(Outer))
    {
        xManager.ReleaseConfigSet(ConfigSet, Self);
        bAdmin = false;

        if (bWasSilent)
        {
            Outer.ReceiveLocalizedMessage(Level.Game.GameMessageClass, 21);
        }
        else
        {
            xManager.AdminExited(Outer);
        }
    }
}

defaultproperties
{
}
