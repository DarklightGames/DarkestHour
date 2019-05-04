//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment extends Actor
    abstract
    notplaceable;

enum EMapIconAttachmentError
{
    ERROR_None,
    ERROR_SpawnFailed
};

var Actor AttachedTo;
var int   Quantized2DPose;
var bool  bUpdatePoseChanges;       // for moving actors
var bool  bOldUpdatePoseChanges;
var bool  bIgnoreGRIUpdates;        // set to true when updates are called from
                                    // somewhere else

var private   byte TeamIndex;
var protected byte VisibilityIndex; // NEUTRAL_TEAM_INDEX -> all; 255 -> hidden

var Material IconMaterial;
var IntBox   IconCoords;
var float    IconScale;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        AttachedTo;

    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, VisibilityIndex, Quantized2DPose;
}

// Called after spawning and setting the base.
function Setup()
{
    SetBase(Owner);

    if (Base != none)
    {
        AttachedTo = Base;
    }

    UpdateQuantized2DPose();
}

function PostBeginPlay()
{
    SetTimer(1.0, true);
}

function Timer()
{
    if (bUpdatePoseChanges)
    {
        UpdateQuantized2DPose();
    }
}

final function Updated()
{
    UpdateVisibilityIndex();

    bOldUpdatePoseChanges = bUpdatePoseChanges;

    if (VisibilityIndex == 255)
    {
        bUpdatePoseChanges = false;
        bAlwaysRelevant = false;
        return;
    }

    bUpdatePoseChanges = bOldUpdatePoseChanges;

    if (bUpdatePoseChanges)
    {
        UpdateQuantized2DPose();
    }

    bAlwaysRelevant = true;
}

function UpdateQuantized2DPose()
{
    local DHGameReplicationInfo GRI;
    local float X, Y;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.GetMapCoords(Location, X, Y);
        Quantized2DPose = class'UQuantize'.static.QuantizeClamped2DPose(X, Y, Rotation.Yaw);
    }
}

// Called when attachment is updated; override it to set custom visibility rules
// (e.g. what happens when actor is inside the Danger Zone).
function UpdateVisibilityIndex()
{
    // Visible to friendly team.
    VisibilityIndex = TeamIndex;
}

final simulated function byte GetVisibilityIndex()
{
    return VisibilityIndex;
}

final function SetTeamIndex(byte TeamIndex)
{
    self.TeamIndex = TeamIndex;

    Updated();
}

final simulated function byte GetTeamIndex()
{
    return TeamIndex;
}

final simulated function vector GetWorldCoords(DHGameReplicationInfo GRI)
{
    local vector L;
    local float X, Y;

    if (AttachedTo != none)
    {
        L.X = AttachedTo.Location.X;
        L.Y = AttachedTo.Location.Y;
    }
    else if (GRI != none)
    {
        class'UQuantize'.static.DequantizeClamped2DPose(Quantized2DPose, X, Y);
        L = GRI.GetWorldCoords(x, Y);
    }

    return L;
}

final simulated function float GetMapIconYaw(DHGameReplicationInfo GRI)
{
    local int WorldYaw;

    if (AttachedTo != none)
    {
        WorldYaw = AttachedTo.Rotation.Yaw;
    }
    else
    {
        class'UQuantize'.static.DequantizeClamped2DPose(Quantized2DPose,,, WorldYaw);
    }

    if (GRI != none)
    {
        return GRI.GetMapIconYaw(WorldYaw);
    }
}

static function OnError(EMapIconAttachmentError Error)
{
    switch(Error)
    {
        case ERROR_SpawnFailed:
            Warn("Failed to spawn map icon attachment!");
    }
}

//==============================================================================
// ICON APPEARANCE
//==============================================================================

simulated function color GetIconColor(DHPlayer PC)
{
    if (PC.GetTeamNum() == TeamIndex)
    {
        return class'DHColor'.default.FriendlyColor;
    }
    else if (PC.GetTeamNum() == 255)
    {
        switch(TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                return class'DHColor'.default.TeamColors[0];
            case ALLIES_TEAM_INDEX:
                return class'DHColor'.default.TeamColors[1];
        }
    }
    else
    {
        return class'UColor'.default.Red;
    }
}

simulated function Material GetIconMaterial(DHPlayer PC)
{
    return default.IconMaterial;
}

simulated function IntBox GetIconCoords(DHPlayer PC)
{
    return default.IconCoords;
}

simulated function float GetIconScale(DHPlayer PC)
{
    return default.IconScale;
}

//==============================================================================
// DANGER ZONE HELPERS
//==============================================================================

final function byte GetOppositeTeamIndex()
{
    switch(TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return ALLIES_TEAM_INDEX;
        case ALLIES_TEAM_INDEX:
            return AXIS_TEAM_INDEX;
        default:
            return TeamIndex;
    }
}

final function ChangeVisibilityInDangerZoneTo(byte InIndex, byte OutIndex)
{
    if (IsInDangerZone())
    {
        VisibilityIndex = InIndex;
        return;
    }

    VisibilityIndex = OutIndex;
}

// To cut down on unnecessary calculations, this can be assigned to get the
// result from somewhere else.
delegate bool IsInDangerZone()
{
    local DHGameReplicationInfo GRI;
    local vector L;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        L = GetWorldCoords(GRI);

        return GRI.IsInDangerZone(L.X, L.Y, TeamIndex);
    }
}

defaultproperties
{
    RemoteRole=ROLE_DumbProxy
    DrawType=DT_None
    bAlwaysRelevant=true
    bReplicateMovement=false

    TeamIndex=NEUTRAL_TEAM_INDEX
    VisibilityIndex=NEUTRAL_TEAM_INDEX

    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    IconScale=0.04
}
