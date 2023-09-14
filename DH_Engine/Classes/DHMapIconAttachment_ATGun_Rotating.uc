//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_ATGun_Rotating extends DHMapIconAttachment_ATGun
    notplaceable;

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
    IconMaterial=TexRotator'DH_InterfaceArt2_tex.Icons.at_topdown_rot'
}
