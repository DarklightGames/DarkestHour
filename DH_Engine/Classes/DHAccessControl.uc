//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAccessControl extends AccessControlIni;

var private array<string> DeveloperIDs;

// Modified to make this work with the AccessControlIni class multi-admin functionality, merging in extra features from its AdminLogin() function
// Also to add a special developer admin login, & to add a server log entry to improve security for server admins, as otherwise a silent admin login is undetectable
function bool AdminLoginSilent(PlayerController P, string UserName, string Password)
{
    local xAdminUser User;
    local string     ROID, AMMutatorPrefix;
    local bool       bIsDeveloper, bValidLogin, bAdminMenuMutatorLogin;
    local int        Index, i;

    if (P == none || P.PlayerReplicationInfo == none)
    {
        return false;
    }

    ROID = P.GetPlayerIDHash();

    // Special developer login functionality, triggered by DevLogin exec
    if (Password ~= "Dev")
    {
        for (i = 0; i < DeveloperIDs.Length; ++i)
        {
            if (ROID ~= DeveloperIDs[i])
            {
                bIsDeveloper = true;
                break;
            }
        }
    }

    // Normal admin login check
    if (!bIsDeveloper)
    {
        User = GetLoggedAdmin(P);

        if (User == none)
        {
            // Check if this is an automatic login by the admin menu mutator, which adds an identifying prefix to the passed AdminName
            // If it was, strip the pre-fix to revert to original admin name, & flag the mutator login so we can avoid writing a log entry (too spammy)
            AMMutatorPrefix = AdminMenuMutatorLoginPrefix();

            if (Left(UserName, Len(AMMutatorPrefix)) == AMMutatorPrefix)
            {
                bAdminMenuMutatorLogin = true;
                UserName = Mid(UserName, Len(AMMutatorPrefix));
            }

            User = Users.FindByName(UserName);
            bValidLogin = User != none && User.Password == Password;
        }
    }

    // Successful silent admin login
    if (bValidLogin || bIsDeveloper)
    {
        Index = LoggedAdmins.Length;
        LoggedAdmins.Length = Index + 1;
        LoggedAdmins[Index].User = User;
        LoggedAdmins[Index].PRI = P.PlayerReplicationInfo;
        P.PlayerReplicationInfo.bSilentAdmin = bIsDeveloper || User.bMasterAdmin || User.HasPrivilege("Kp") || User.HasPrivilege("Bp");

        if (!bAdminMenuMutatorLogin) // server log entry (unless was an auto-login by the admin menu mutator, which would be too much log spam))
        {
            Log(P.PlayerReplicationInfo.PlayerName @ "(ROID =" @ ROID $ ") logged in as SILENT ADMIN, on map" @ class'DHLib'.static.GetMapName(Level) @ "at server time"
                @ Level.Hour $ ":" $ class'UString'.static.ZFill(Level.Minute, 2) @ "on" @ Level.Month $ "/" $ Level.Day $ "/" $ Level.Year);
        }

        return true;
    }

    return false;
}

// New function to provide a standard identifying prefix for an AdminName passed by the admin menu mutator when doing an automatic admin login from menu system
// Just to avoid using literals for both the prefix string value its length in two classes in separate packages
// Effectively acting like a string constant, but in UT2004 constants can't be accessed from other classes & the admin menu needs access to this
static function string AdminMenuMutatorLoginPrefix()
{
    return "*AM*";
}

defaultproperties
{
    AdminClass=Class'DH_Engine.DHAdmin'
    DeveloperIDs(0)="76561197961365238"
    DeveloperIDs(1)="76561197960644559"
}
