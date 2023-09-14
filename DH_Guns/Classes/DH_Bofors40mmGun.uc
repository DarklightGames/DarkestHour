//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Bofors40mmGun extends DHATGun;

defaultproperties
{
    VehicleNameString="Bofors 40mm gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Bofors40mmCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Bofors_anm.Bofors40mm_base'
    Skins(0)=Texture'DH_Bofors_tex.Bofors40mmGun'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Bofors40mm.Bofors40mmGun_destroyed'
    VehicleHudImage=Texture'DH_Bofors_tex.Bofors40mm_HUD_base'
    VehicleHudTurret=TexRotator'DH_Bofors_tex.Bofors40mm_HUD_gun_rot'
    VehicleHudTurretLook=TexRotator'DH_Bofors_tex.Bofors40mm_HUD_gun_look'
    ShadowZOffset=30.0
    ExitPositions(1)=(X=-35.0,Y=-90.0,Z=60.0)
    VehicleMass=11.0
    SupplyCost=1250
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_StaticAA'
}
