//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Gun extends DH_ATGun;

//#exec OBJ LOAD FILE=..\StaticMeshes\DH_Flak38_stc.usx
#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flak38_tex.utx

defaultproperties
{
    VehicleHudTurret=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_look'
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn',WeaponBone="turret_placement")
    DestroyedVehicleMesh=StaticMesh'DH_Flakvierling38_stc.flakv38.flakv38_destroyed'    //TODO: change
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DamagedEffectClass=none
    DamagedEffectHealthSmokeFactor=0.0
    DamagedEffectHealthMediumSmokeFactor=0.0
    DamagedEffectHealthHeavySmokeFactor=0.0
    VehicleHudImage=texture'DH_Flakvierling38_tex.flak.flakv38_base'
    VehicleHudOccupantsX(0)=0.0
    VehicleHudOccupantsX(1)=0.0
    VehicleNameString="Flak 38"
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_wheels'
}
