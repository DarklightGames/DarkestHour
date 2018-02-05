//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHArtillery extends Actor
    abstract
    notplaceable;

var protected localized string  MenuName;
var Material                    MenuIcon;

var Material                    MapIcon;
var IntBox                      MapIconTextureCoords;

var int                         TeamIndex;
var PlayerController            Requester;

function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;

    if (Role == ROLE_Authority)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none)
        {
            GRI.AddArtillery(self);
        }
    }
}

static function string GetMenuName()
{
    return default.MenuName;
}

// Returns true if the specified player is able to request this class of artillery.
static function bool CanBeRequestedBy(DHPlayer PC)
{
    local DHPlayerReplicationInfo PRI;
    local DHRoleInfo RI;

    if (PC == none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    RI = DHRoleInfo(PRI.RoleInfo);

    if (RI == none)
    {
        return false;
    }

    return RI.bIsArtilleryOfficer || PRI.IsSquadLeader();
}

// These override function are meant to facilitate gathering the limit and
// interval times from sources other than those laid out in the ArtilleryTypes
// array. This is used in the legacy artillery type.
static function int GetLimitOverride(int TeamIndex, LevelInfo Level)
{
    return -1;
}

static function int GetConfirmIntervalSecondsOverride(int TeamIndex, LevelInfo Level)
{
    return -1;
}

defaultproperties
{
    DrawType=DT_None
    RemoteRole=ROLE_SimulatedProxy
    MenuName="Artillery Barrage"
    bAlwaysRelevant=true

    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.Artillery'

    MapIcon=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    MapIconTextureCoords=(X1=0,Y1=64,X2=63,Y2=127)
}

