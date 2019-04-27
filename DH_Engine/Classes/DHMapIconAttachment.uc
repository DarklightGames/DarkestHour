//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment extends Actor
    abstract
    notplaceable;

var Actor AttachedTo;
var int   Quantized2DPose;
var bool  bUpdatePoseChanges; // for moving actors

var private int AxisAttachmentIndex;
var private int AlliesAttachmentIndex;

var protected byte TeamIndex;
var protected byte VisibilityIndex;

var Material IconMaterial;
var IntBox   IconCoords;
var color    IconTeamColors[2];
var float    IconScale;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        AttachedTo;

    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, VisibilityIndex, Quantized2DPose;
}

// Called after spawning; normally you set the team index after.
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

function Destroyed()
{
    UnregisterAttachment();

    super.Destroyed();
}

function Timer()
{
    if (bUpdatePoseChanges)
    {
        UpdateQuantized2DPose();
    }
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

function SetTeamIndex(byte TeamIndex)
{
    self.TeamIndex = TeamIndex;

    RegisterAttachment();
}

simulated function byte GetTeamIndex()
{
    return TeamIndex;
}

// Called when registered/updated; override it to set custom visibility rules
// (e.g. what happens when actor is inside the Danger Zone).
function UpdateVisibilityIndex()
{
    // Visible only to the same team.
    VisibilityIndex = TeamIndex;
}

simulated function byte GetVisibilityIndex()
{
    return VisibilityIndex;
}

simulated function vector GetWorldCoords(DHGameReplicationInfo GRI)
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

simulated function float GetMapIconYaw(DHGameReplicationInfo GRI)
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

final function RegisterAttachment()
{
    local DHGameReplicationInfo GRI;

    UpdateVisibilityIndex();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Register for AXIS || EVERYONE
    if (VisibilityIndex == AXIS_TEAM_INDEX && AlliesAttachmentIndex != -1)
    {
        GRI.RemoveMapIconAttachment(ALLIES_TEAM_INDEX, AlliesAttachmentIndex);
        AlliesAttachmentIndex = -1;
    }

    if (VisibilityIndex != ALLIES_TEAM_INDEX && AxisAttachmentIndex == -1)
    {
        AxisAttachmentIndex = GRI.AddAxisMapIconAttachment(self);
    }

    // Register for ALLIES || EVERYONE
    if (VisibilityIndex == ALLIES_TEAM_INDEX && AxisAttachmentIndex != -1)
    {
        GRI.RemoveMapIconAttachment(AXIS_TEAM_INDEX, AxisAttachmentIndex);
        AxisAttachmentIndex = -1;
    }

    if (VisibilityIndex != AXIS_TEAM_INDEX && AlliesAttachmentIndex == -1)
    {
        AlliesAttachmentIndex = GRI.AddAlliesMapIconAttachment(self);
    }
}

final function UnregisterAttachment()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    if (AxisAttachmentIndex != -1)
    {
        GRI.RemoveMapIconAttachment(AXIS_TEAM_INDEX, AxisAttachmentIndex);
        AxisAttachmentIndex = -1;
    }

    if (AlliesAttachmentIndex == -1)
    {
        GRI.RemoveMapIconAttachment(ALLIES_TEAM_INDEX, AlliesAttachmentIndex);
        AlliesAttachmentIndex = -1;
    }
}

//==============================================================================
// ICON APPEARANCE
//==============================================================================

simulated function color GetIconColor(DHPlayer PC)
{
    if (PC.GetTeamNum() == TeamIndex ||
        (VisibilityIndex == NEUTRAL_TEAM_INDEX && TeamIndex == ALLIES_TEAM_INDEX))
    {
        // Friendly / Allies (for spectator, if icon is visible to both teams)
        return default.IconTeamColors[1];
    }
    else if (PC.GetTeamNum() != TeamIndex ||
             (VisibilityIndex == NEUTRAL_TEAM_INDEX && TeamIndex == AXIS_TEAM_INDEX))
    {
        // Enemy / Axis
        return default.IconTeamColors[0];
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

function byte GetVisibilityIndexInDangerZone(byte DefaultIndex)
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Everything slurped by the Danger Zone becomes visible to the enemy team,
    // and hidden for friendly troops.
    if (IsInDangerZone(GRI))
    {
        switch(TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                return ALLIES_TEAM_INDEX;
            case ALLIES_TEAM_INDEX:
                return AXIS_TEAM_INDEX;
            default:
                return NEUTRAL_TEAM_INDEX;
        }
    }

    return DefaultIndex;
}

simulated function bool IsInDangerZone(DHGameReplicationInfo GRI)
{
    local vector L;

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

    AlliesAttachmentIndex=-1
    AxisAttachmentIndex=-1

    TeamIndex=NEUTRAL_TEAM_INDEX
    VisibilityIndex=NEUTRAL_TEAM_INDEX

    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    IconTeamColors[0]=(R=255,G=0,B=0,A=255)
    IconTeamColors[1]=(R=0,G=124,B=252,A=255)
    IconScale=0.04
}
