//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M5Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="3-inch Gun M5"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M5GunCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M5Gun_anm.M5_base'
    Skins(0)=Texture'DH_M5Gun_tex.m5.m5'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.M5.M5_destroyed'
    VehicleHudImage=Texture'DH_M5Gun_tex.HUD.m5_body'
    VehicleHudTurret=TexRotator'DH_M5Gun_tex.HUD.m5_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M5Gun_tex.HUD.m5_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ShadowZOffset=20.0
    ExitPositions(1)=(X=-100.00,Y=-30.00,Z=35.00)
    VehicleMass=11.0
    SupplyCost=1650
    ConstructionPlacementOffset=(Z=-2)
    bCanBeRotated=true
    PlayersNeededToRotate=2
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Rotating'
}
