//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Vehicle extends DHMapIconAttachment
    notplaceable;

function EVisibleFor GetVisibility()
{
    return VISIBLE_None;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_Enemy;
}

simulated function Material GetIconMaterial(DHPlayer PC)
{
    local Material RotatedMaterial;

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
}
