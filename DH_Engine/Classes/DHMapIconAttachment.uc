//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment extends Actor
    abstract
    notplaceable;

enum EMapIconAttachmentError
{
    ERROR_None,
    ERROR_SpawnFailed
};

enum EVisibleFor
{
    VISIBLE_None,
    VISIBLE_Team,
    VISIBLE_Enemy,
    VISIBLE_All
};

var Material  IconMaterial;
var IntBox    IconCoords;
var float     IconScale;

var Actor     AttachedTo;
var bool      bTrackMovement;    // for moving actors
var bool      bIgnoreGRIUpdates; // call updates from somewhere else

var           int  TimerCount;
var           int  Quantized2DPose;
var private   int  OldQuantized2DPose;
var private   int  OldLocationX;
var private   int  OldLocationY;

var private   byte TeamIndex;
var protected byte VisibilityIndex;

var           int  TrackingUpdateIntervalSeconds;
var           bool bTrackDangerZone;
var           bool bInDangerZone;
var private   bool bOldInDangerZone;

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
    if (Base != none)
    {
        AttachedTo = Base;
    }
}

function Timer()
{
    --TimerCount;

    if (TimerCount > 0)
    {
        if (bAlwaysRelevant)
        {
            UpdateQuantized2DPose();
            OldQuantized2DPose = Quantized2DPose;
        }

        return;
    }

    ResetTimerCount();

    if (IsMoving())
    {
        GotoState('Tracking');
        UpdateDangerZoneStatus();
    }
    else
    {
        GotoState('');
    }
}

final function ResetTimerCount()
{
    TimerCount = Max(TrackingUpdateIntervalSeconds, 0);
}

final function bool IsMoving()
{
    local int X, Y;
    local bool bIsMoving;

    // To save on replication and conversions, quantized pose won't be updated
    // when icon is invisible. When that happens, we fallback to comparing
    // world locations.
    if (bAlwaysRelevant)
    {
        UpdateQuantized2DPose();

        bIsMoving = bTrackDangerZone && OldQuantized2DPose != Quantized2DPose;

        OldQuantized2DPose = Quantized2DPose;
    }
    else if (Base != none)
    {
        X = int(Base.Location.X);
        Y = int(Base.Location.Y);

        bIsMoving = bTrackDangerZone && (OldLocationX != X || OldLocationY != Y);

        OldLocationX = X;
        OldLocationY = Y;
    }

    return bIsMoving;
}

state Tracking
{
    function BeginState()
    {
        bIgnoreGRIUpdates = false;
    }

    function EndState()
    {
        UpdateDangerZoneStatus();
        bIgnoreGRIUpdates = default.bIgnoreGRIUpdates;
    }
}

final function UpdateDangerZoneStatus(optional bool bForceUpdateVisibility)
{
    bInDangerZone = IsInDangerZone();

    if (bInDangerZone != bOldInDangerZone || bForceUpdateVisibility)
    {
        bOldInDangerZone = bInDangerZone;

        if (bInDangerZone)
        {
            SetVisibilityIndex(GetVisibilityInDangerZone());
        }
        else
        {
            SetVisibilityIndex(GetVisibility());
        }
    }
}

final function Updated()
{
    if (bTrackDangerZone)
    {
        UpdateDangerZoneStatus();
    }
}

final function SetVisibilityIndex(EVisibleFor VisibleFor)
{
    if (bTrackMovement)
    {
        ResetTimerCount();
        SetTimer(1.0, true);
    }

    switch (VisibleFor)
    {
        case VISIBLE_None:
            VisibilityIndex = 255;
            bAlwaysRelevant = false;

            return;

        case VISIBLE_Team:
            VisibilityIndex = TeamIndex;
            break;

        case VISIBLE_Enemy:
            if (TeamIndex < 2)
            {
                VisibilityIndex = TeamIndex ^ 1;
            }
            else
            {
                VisibilityIndex = TeamIndex;
            }
            break;

        case VISIBLE_All:
            VisibilityIndex = NEUTRAL_TEAM_INDEX;
    }

    bAlwaysRelevant = true;

    if (!IsInState('Tracking'))
    {
        UpdateQuantized2DPose();
        OldQuantized2DPose = Quantized2DPose;
    }
}

final simulated function byte GetVisibilityIndex()
{
    return VisibilityIndex;
}

final function SetTeamIndex(byte TeamIndex)
{
    self.TeamIndex = TeamIndex;

    if (bTrackDangerZone)
    {
        UpdateDangerZoneStatus(true);
    }
    else
    {
        SetVisibilityIndex(GetVisibility());
    }
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

final function UpdateQuantized2DPose()
{
    local DHGameReplicationInfo GRI;
    local float X, Y;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none && AttachedTo != none)
    {
        GRI.GetMapCoords(AttachedTo.Location, X, Y);
        Quantized2DPose = class'UQuantize'.static.QuantizeClamped2DPose(X, Y, AttachedTo.Rotation.Yaw);
    }
}

static function OnError(EMapIconAttachmentError Error)
{
    if (Error == ERROR_SpawnFailed)
    {
        Warn("Failed to spawn map icon attachment!");
    }
}

// Assign to retreive the status from somewhere else
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

// Override to define who can see the icon
function EVisibleFor GetVisibility();
function EVisibleFor GetVisibilityInDangerZone();

//==============================================================================
// ICON APPEARANCE
//==============================================================================

simulated function color GetIconColor(DHPlayer PC)
{
    local byte PlayerTeamIndex;

    if (PC != none)
    {
        PlayerTeamIndex = PC.GetTeamNum();

        if (PlayerTeamIndex > 1)
        {
            if (TeamIndex < arraycount(class'DHColor'.default.TeamColors))
            {
                return class'DHColor'.default.TeamColors[TeamIndex];
            }
        }
        else if (PlayerTeamIndex != TeamIndex && TeamIndex < 2)
        {
            return class'UColor'.default.Red;
        }
    }

    return class'DHColor'.default.FriendlyColor;
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

defaultproperties
{
    RemoteRole=ROLE_DumbProxy
    DrawType=DT_None
    bAlwaysRelevant=true
    bReplicateMovement=false

    TeamIndex=NEUTRAL_TEAM_INDEX
    VisibilityIndex=NEUTRAL_TEAM_INDEX

    TrackingUpdateIntervalSeconds=3
    bTrackDangerZone=true

    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    IconScale=0.04
}
