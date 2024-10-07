//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Vehicle extends DHMapIconAttachment
    notplaceable;

// Track the driver of the vehicle so we can display the correct icon color
// depending on the driver's team and squad.
var private DHPlayerReplicationInfo DriverPRI;
var class<DHVehicle>                VehicleClass;
var Color                           UnoccupiedColor;
var TexRotator                      MyIconMaterial;

replication
{
    reliable if (Role == ROLE_Authority && bNetInitial)
        VehicleClass;

    reliable if (Role == ROLE_Authority && bNetDirty)
        DriverPRI;
}

simulated function bool IsOccupied()
{
    return DriverPRI != none;
}

function PostNetBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Create the material instance for the icon.
        MyIconMaterial = TexRotator(Level.ObjectPool.AllocateObject(class'TexRotator'));
    }
}

function DHPlayerReplicationInfo GetPrimaryOccupant()
{
    local ROVehicle V;
	local int i;

    V = ROVehicle(AttachedTo);

    if (V != none && V.Controller != none)
    {
        return DHPlayerReplicationInfo(V.Controller.PlayerReplicationInfo);
    }

	for (i = 0; i < V.WeaponPawns.Length; i++)
    {
		if (V.WeaponPawns[i] != none && V.WeaponPawns[i].Controller != none && !V.WeaponPawns[i].IsA('DHPassengerPawn'))
        {
			return DHPlayerReplicationInfo(V.WeaponPawns[i].PlayerReplicationInfo);
        }
    }
    
    return none;
}

function Timer()
{
    super.Timer();
    
    DriverPRI = GetPrimaryOccupant();
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
    if (PC != none)
    {
        MyIconMaterial.Material = VehicleClass.default.MapIconMaterial;
        MyIconMaterial.UOffset = MyIconMaterial.Material.MaterialUSize() / 2;
        MyIconMaterial.VOffset = MyIconMaterial.Material.MaterialVSize() / 2;
        MyIconMaterial.Rotation.Yaw = GetMapIconYaw(DHGameReplicationInfo(PC.GameReplicationInfo));
    }

    return MyIconMaterial;
}

defaultproperties
{
    bTrackMovement=true
    IconMaterial=TexRotator'DH_InterfaceArt2_tex.Icons.truck_topdown_rot'
    IconScale=0.035
    UnoccupiedColor=(R=192,G=192,B=192,A=255)
}
