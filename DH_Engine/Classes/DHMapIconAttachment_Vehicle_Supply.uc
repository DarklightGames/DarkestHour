//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Vehicle_Supply extends DHMapIconAttachment_Vehicle
    notplaceable;

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

    if (PC != none)
    {
        if (PC.GetTeamNum() != GetTeamIndex())
        {
            RotatedMaterial = class'DHMapIconAttachment_Vehicle'.default.IconMaterial;
        }
        else
        {
            RotatedMaterial = default.IconMaterial;
        }

        TexRotator(RotatedMaterial).Rotation.Yaw = GetMapIconYaw(DHGameReplicationInfo(PC.GameReplicationInfo));

        return RotatedMaterial;
    }
}

defaultproperties
{
    IconMaterial=TexRotator'DH_GUI_Tex.GUI.supply_point_rot'
}
