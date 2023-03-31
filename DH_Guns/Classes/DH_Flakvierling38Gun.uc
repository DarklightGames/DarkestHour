//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flakvierling38Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="2cm Flakvierling 38 gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Flakvierling38CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Flak38_anm.flakvierling_base'
    Skins(0)=Texture'DH_Artillery_tex.flakvierling.FlakVeirling38'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling38_dest'
    VehicleHudImage=Texture'DH_Artillery_tex.ATGun_Hud.flakv38_base'
    VehicleHudTurret=TexRotator'DH_Artillery_tex.ATGun_Hud.flakv38_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.ATGun_Hud.flakv38_turret_look'
    ExitPositions(1)=(X=-100.0,Y=40.0,Z=50.0)  // right of seat
    ExitPositions(2)=(X=-100.0,Y=-40.0,Z=50.0) // left
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_StaticAA'
}
