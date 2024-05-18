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
var private array<string>           GloballyBannedIDs;

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

static function bool IsGloballyBanned(string ROID)
{
    local int i;

    for (i = 0; i < default.GloballyBannedIDs.Length; ++i)
    {
        if (ROID ~= default.GloballyBannedIDs[i])
        {
            return true;
        }
    }
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

// Overriden to add global bans
function int CheckID(string CDHash)
{
    local int i;
    local string id;

    if (IsGloballyBanned(CDHash))
    {
        return 2;
    }

    for (i = 0; i < BannedIDs.Length; i++)
    {
        id = Left(BannedIDs[i], InStr(BannedIDs[i], " "));

        // Use the old system if the Steam system isn't enabled
        if (id == "")
        {
            id = Left(BannedIDs[i], 32);
        }

        if (CDHash ~= id)//STEAMAUTH -- ~=Left(BannedIDs[i],32) )
        {
            return 2;
        }
    }

    for (i = 0; i < SessionBannedIDs.Length; i++)
    {
        id = Left(SessionBannedIDs[i], InStr(SessionBannedIDs[i], " "));

        // Use the old system if the Steam system isn't enabled
        if (id == "")
        {
            id = Left(SessionBannedIDs[i], 32);
        }

        if (CDHash ~= id)//STEAMAUTH -- ~=Left(SessionBannedIDs[i],32) )
        {
            return 1;
        }
    }

    return 0;
}

defaultproperties
{
    IPBanned="You cannot join this server, you have been banned."
    SessionBanned="You cannot join this server until it changes level."

    AdminClass=class'DH_Engine.DHAdmin'
    DeveloperIDs(0)="76561197989090226" // Napoleon Blownapart
    DeveloperIDs(1)="76561197960644559" // Basnett
    DeveloperIDs(2)="76561198043869714" // DirtyBirdy
    DeveloperIDs(3)="76561198046844470" // Matty
    DeveloperIDs(4)="76561197991612787" // Razorneck
    DeveloperIDs(5)="76561198025788618" // WOLFkraut
    DeveloperIDs(6)="76561197992062636" // eksha
    DeveloperIDs(7)="76561198020507621" // jwjw
    DeveloperIDs(8)="76561198176185585" // Backis
    DeveloperIDs(9)="76561198144056227" // Mechanic
    DeveloperIDs(10)="76561197981578171"// Enfield

    // Mac clients are unable to determine their patron status
    // normally, so we hard-code these
    Patrons(0)=(ROID="76561198066643021",Tier="bronze") // PFC Patison
    Patrons(1)=(ROID="76561198431789713",Tier="lead") // Bearnoceros
    Patrons(2)=(ROID="76561198018980127",Tier="lead") // MacEwan
    Patrons(3)=(ROID="76561198048993064",Tier="lead") // Ches217
    Patrons(4)=(ROID="76561197981301331",Tier="lead") // Monni
    Patrons(5)=(ROID="76561198256117403",Tier="lead") // Vic
    Patrons(6)=(ROID="76561198847955145",Tier="lead") // MaDeuce

    // GLOBAL BANS
    // Double check that ID is correct before adding it to the list!

    // 76561197984321708 alts
    GloballyBannedIDs(0)="76561197984321708"
    GloballyBannedIDs(1)="76561198054652352"
    GloballyBannedIDs(2)="76561198799736606"
    GloballyBannedIDs(3)="76561199092962089"
    GloballyBannedIDs(4)="76561199215637308"
    GloballyBannedIDs(5)="76561199469229247"
    GloballyBannedIDs(6)="76561199487793588"
    GloballyBannedIDs(7)="76561199500513625"
    GloballyBannedIDs(8)="76561199501293525"
    GloballyBannedIDs(9)="76561199521424863"
    GloballyBannedIDs(10)="76561199539630085"
    GloballyBannedIDs(11)="76561199553169889"
    GloballyBannedIDs(12)="76561199574520909"
    GloballyBannedIDs(13)="76561199634932689"
    GloballyBannedIDs(14)="76561199640196259"

    // 76561198202576201 alts
    GloballyBannedIDs(15)="76561198202576201"
    GloballyBannedIDs(16)="76561199385553208"
    GloballyBannedIDs(17)="76561199474852956"
    GloballyBannedIDs(18)="76561199488873541"
    GloballyBannedIDs(19)="76561199563295062"
    GloballyBannedIDs(20)="76561199645254168"

    // 76561197995652829 alts
    GloballyBannedIDs(21)="76561197995652829"
    GloballyBannedIDs(22)="76561198201322109"
}
