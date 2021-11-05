//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHArtillery extends Actor
    abstract
    notplaceable
    dependson(DHGameReplicationInfo);

var DHGameReplicationInfo.EArtilleryType              ArtilleryType;

var localized protected string  MenuName;
var Material                    MenuIcon;

var protected int               TeamIndex;
var PlayerController            Requester;

var bool                        bCanBeCancelled;

var class<DHMapMarker> ActiveArtilleryMarkerClass;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, Requester;
}

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

function Reset()
{
    Destroy();
}

static function string GetMenuName()
{
    return default.MenuName;
}

// Returns true if the specified player is able to request this class of artillery.
static function bool CanBeRequestedBy(DHPlayer PC)
{
    return PC != none && PC.IsArtillerySpotter();
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

function OnTeamIndexChanged();

simulated function int GetTeamIndex()
{
    return TeamIndex;
}

function SetTeamIndex(int TeamIndex)
{
    if (self.TeamIndex != TeamIndex)
    {
        self.TeamIndex = TeamIndex;

        OnTeamIndexChanged();
    }
}

simulated function bool IsParadrop()
{
    return false;
}

defaultproperties
{
    DrawType=DT_None
    RemoteRole=ROLE_SimulatedProxy
    MenuName="Long-Range Artillery"
    bAlwaysRelevant=true

    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.Artillery'

    bCanBeCancelled=true
}

