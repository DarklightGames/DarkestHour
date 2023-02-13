//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAccessControl extends AccessControlINI;

// WARNING: Changing anything in here would be a great way to get your server blacklisted.

struct Patron
{
    var string ROID;
    var string Tier;
};

var private array<string>           DeveloperIDs;
var private array<Patron>           Patrons; // A list of patreon ROIDs for users that are on MAC and don't work with normal system

function bool AdminLogin(PlayerController P, string Username, string Password)
{
    local xAdminUser    User;
    local int           Index;
    local bool          bValidLogin;

    if (P == none)
    {
        return false;
    }

    User = GetLoggedAdmin(P);

    if (User == none)
    {
        User = Users.FindByName(UserName);
        bValidLogin = User != none && User.Password == Password;
    }

    if (bValidLogin)
    {
        Index = LoggedAdmins.Length;
        LoggedAdmins.Length = Index + 1;
        LoggedAdmins[index].User = User;
        LoggedAdmins[index].PRI = P.PlayerReplicationInfo;
        P.PlayerReplicationInfo.bAdmin = User.bMasterAdmin || User.HasPrivilege("Kp") || User.HasPrivilege("Bp");
        return true;
    }

    return false;
}

// Modified to make this work with the AccessControlIni class multi-admin functionality, merging in extra features from its AdminLogin() function
// AdminLoginSilent is not reliable, many commands do not work
function bool AdminLoginSilent(PlayerController P, string UserName, string Password)
{
    local xAdminUser User;
    local string     ROID, AMMutatorPrefix;
    local bool       bValidLogin, bAdminMenuMutatorLogin;
    local int        Index;

    if (P == none || P.PlayerReplicationInfo == none)
    {
        return false;
    }

    // Normal admin login check
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

    // Successful silent admin login
    if (bValidLogin)
    {
        Index = LoggedAdmins.Length;
        LoggedAdmins.Length = Index + 1;
        LoggedAdmins[Index].User = User;
        LoggedAdmins[Index].PRI = P.PlayerReplicationInfo;
        P.PlayerReplicationInfo.bSilentAdmin = User.bMasterAdmin || User.HasPrivilege("Kp") || User.HasPrivilege("Bp");

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

static function bool IsDeveloper(string ROID)
{
    local int i;

    for (i = 0; i < default.DeveloperIDs.Length; ++i)
    {
        if (ROID ~= default.DeveloperIDs[i])
        {
            return true;
        }
    }

    return false;
}

// This only gets the patron level off the PatreonIDs array in the default properties below, not from the webserver
// This is used to fix an issue with MAC/Linux not being able to properly use the HTTP request function
static function string GetPatronTier(string ROID)
{
    local int i;

    for (i = 0; i < default.Patrons.Length; ++i)
    {
        if (ROID ~= default.Patrons[i].ROID)
        {
            return default.Patrons[i].Tier;
        }
    }

    return "";
}

defaultproperties
{
    IPBanned="You cannot join this server, you have been banned."
    SessionBanned="You cannot join this server until it changes level."

    AdminClass=class'DH_Engine.DHAdmin'
    DeveloperIDs(0)="76561197989090226" // Napoleon Blownapart
    DeveloperIDs(1)="76561197960644559" // Basnett
    DeveloperIDs(2)="76561198043869714" // DirtyBirdy
    DeveloperIDs(3)="76561198066643021" // Patison
    DeveloperIDs(4)="76561198046844470" // Matty
    DeveloperIDs(5)="76561197991612787" // Razorneck
    DeveloperIDs(6)="76561198025788618" // WOLFkraut
    DeveloperIDs(7)="76561197992062636" // eksha
    DeveloperIDs(8)="76561197989139694" // mimi
    DeveloperIDs(9)="76561198020507621" // jwjw
    DeveloperIDs(10)="76561198176185585" // Backis
    DeveloperIDs(11)="76561198162915303" // Caverne

    // Mac clients are unable to determine their patron status
    // normally, so we hard-code these
    Patrons(0)=(ROID="76561198066643021",Tier="bronze") // PFC Patison
    Patrons(1)=(ROID="76561198431789713",Tier="lead") // Bearnoceros
    Patrons(2)=(ROID="76561198018980127",Tier="lead") // MacEwan
    Patrons(3)=(ROID="76561198048993064",Tier="lead") // Ches217
    Patrons(4)=(ROID="76561197981301331",Tier="lead") // Monni
    Patrons(5)=(ROID="76561198256117403",Tier="lead") // Vic
    Patrons(6)=(ROID="76561198847955145",Tier="lead") // MaDeuce
}
