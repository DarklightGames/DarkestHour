//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountGun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_M45_anm.ukx

defaultproperties
{
    VehicleHudTurret=TexRotator'DH_Artillery_tex.ATGun_Hud.m45_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.ATGun_Hud.m45_turret_look'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M45QuadmountCannonPawn',WeaponBone="Turret_placement")
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling38_dest'
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'   //i feel like these are redundant
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DamagedEffectClass=none
    DamagedEffectHealthSmokeFactor=0.0
    DamagedEffectHealthMediumSmokeFactor=0.0
    DamagedEffectHealthHeavySmokeFactor=0.0
    VehicleHudImage=texture'DH_Artillery_tex.ATGun_Hud.m45_body'
    VehicleHudOccupantsX(0)=0.0
    VehicleHudOccupantsX(1)=0.0
    ExitPositions(1)=(X=-100.0,Y=40.0,Z=50.0)  // right of seat
    ExitPositions(2)=(X=-100.0,Y=-40.0,Z=50.0) // left
    VehicleNameString="M45 Quadmount"
    Mesh=SkeletalMesh'DH_M45_anm.m45_base_trailer'
    VehicleTeam=1
}
