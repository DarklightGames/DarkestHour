//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Vehicle extends DHMapIconAttachment
    notplaceable;

// Track the driver of the vehicle so we can display the correct icon color
// depending on the driver's team and squad.
var private DHPlayerReplicationInfo DriverPRI;

var Color                           UnoccupiedColor;

replication
{
    reliable if (Role == ROLE_Authority && bNetDirty)
        DriverPRI;
}

simulated function bool IsOccupied()
{
    return DriverPRI != none;
}

function Timer()
{
    local Vehicle V;

    super.Timer();

    V = Vehicle(AttachedTo);

    if (V != none && V.Controller != none)
    {
        DriverPRI = DHPlayerReplicationInfo(V.Controller.PlayerReplicationInfo);
    }
    else
    {
        DriverPRI = none;
    }
}

simulated function Color GetIconColor(DHPlayer PC)
{
    local Color C;

    // If the vehicle is owned by the enemy, the icon is red.
    // If the vehicle is owned by the player's team, the icon is blue if occupied, grey if not,
    // and green if the player is in the same squad.
    if (PC.PlayerReplicationInfo == DriverPRI)
    {
        return class'DHColor'.default.SelfColor;
    }

    if (PC.GetTeamNum() == GetTeamIndex())
    {
        if (IsOccupied())
        {
            if (PC.GetSquadIndex() == DriverPRI.SquadIndex)
            {
                return class'DHColor'.default.SquadColor;
            }
        }
        else
        {
            return UnoccupiedColor;
        }
    }

    return super.GetIconColor(PC);
}

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_All;
}

simulated function Material GetIconMaterial(DHPlayer PC)
{
    local Material RotatedMaterial;

    // TODO: get the icon from the vehicle class, not the attachment class.
    // this will eliminate the class-spam.

    if (PC != none)
    {
        RotatedMaterial = default.IconMaterial;
        TexRotator(RotatedMaterial).Rotation.Yaw = GetMapIconYaw(DHGameReplicationInfo(PC.GameReplicationInfo));
        return RotatedMaterial;
    }
}

defaultproperties
{
    bTrackMovement=true
    IconMaterial=TexRotator'DH_InterfaceArt2_tex.Icons.truck_topdown_rot'
    IconScale=0.035
    UnoccupiedColor=(R=192,G=192,B=192,A=255)
}
