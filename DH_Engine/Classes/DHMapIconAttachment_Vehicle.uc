//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_Vehicle extends DHMapIconAttachment
    notplaceable;

// VISIBILITY
// Normal -> nobody
// Danger Zone -> enemy
function UpdateVisibilityIndex()
{
    ChangeVisibilityInDangerZoneTo(class'UMath'.static.SwapFirstPair(GetTeamIndex()), 255);
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
    bUpdatePoseChanges=true
    IconMaterial=TexRotator'DH_GUI_Tex.GUI.supply_point_rot'
    IconScale=0.03
}
