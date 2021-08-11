//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M3Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="M3 AT"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M3GunCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M3AT_anm.body'
    Skins(0)=Texture'DH_M3AT_tex.gun.M3_Light_AT_Gun'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.M5.M5_destroyed' //TODO: Replace
    VehicleHudImage=Texture'DH_M5Gun_tex.HUD.m5_body'   // TODO: Replace
    VehicleHudTurret=TexRotator'DH_M5Gun_tex.HUD.m5_turret_rot' // TODO: Replace
    VehicleHudTurretLook=TexRotator'DH_M5Gun_tex.HUD.m5_turret_look' // TODO: Replace
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ShadowZOffset=20.0
    ExitPositions(1)=(X=-100.00,Y=-30.00,Z=35.00)
    VehicleMass=04.5
    SupplyCost=250
    ConstructionPlacementOffset=(Z=-2)
    bCanBeRotated=true
    PlayersNeededToRotate=1
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'
}
