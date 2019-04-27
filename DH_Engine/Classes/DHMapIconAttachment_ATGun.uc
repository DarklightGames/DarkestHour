//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMapIconAttachment_ATGun extends DHMapIconAttachment
    dependson(DHATGun)
    notplaceable;

var Material StationaryIconMaterial;
var Material StationaryAutoIconMaterial;

var DHATGun.EATGunType ATGunType;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        ATGunType;
}

function Setup()
{
    local DHATGun Gun;

    super.Setup();

    if (Owner != none)
    {
        Gun = DHATGun(Owner);

        if (Gun == none)
        {
            return;
        }
    }

    ATGunType = Gun.ATGunType;

    bUpdatePoseChanges = ATGunType != TYPE_Stationary && ATGunType != TYPE_StationaryAuto;

    // Register the attachment
    SetTeamIndex(Gun.VehicleTeam);
}

function UpdateVisibilityIndex()
{
    VisibilityIndex = GetVisibilityIndexInDangerZone(TeamIndex);
}

simulated function Material GetIconMaterial(DHPlayer PC)
{
    local Material RotatedMaterial;

    switch(ATGunType)
    {
        case TYPE_Stationary:
            return default.StationaryIconMaterial;

        case TYPE_StationaryAuto:
            return default.StationaryAutoIconMaterial;
    }

    if (PC != none)
    {
        RotatedMaterial = default.IconMaterial;
        TexRotator(RotatedMaterial).Rotation.Yaw = GetMapIconYaw(DHGameReplicationInfo(PC.GameReplicationInfo));
        return RotatedMaterial;
    }
}

defaultproperties
{
    IconMaterial=TexRotator'DH_InterfaceArt2_tex.Icons.at_topdown_rot'
    StationaryIconMaterial=Texture'DH_InterfaceArt2_tex.Icons.at_static_topdown'
    StationaryAutoIconMaterial=Texture'DH_InterfaceArt2_tex.Icons.aa_topdown'
}
