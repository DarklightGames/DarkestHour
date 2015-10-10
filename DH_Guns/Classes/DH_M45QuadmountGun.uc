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
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M45QuadmountCannonPawn',WeaponBone="body")
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling38_dest' // TEMP - replace with M45 destroyed static mesh
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DamagedEffectClass=none
    VehicleTeam=1
    BeginningIdleAnim=
    VehicleHudImage=texture'DH_Artillery_tex.ATGun_Hud.m45_body'
    VehicleHudOccupantsX(0)=0.0
    VehicleHudOccupantsX(1)=0.0
    ExitPositions(1)=(X=-100.0,Y=40.0,Z=50.0)  // right of seat
    ExitPositions(2)=(X=-100.0,Y=-40.0,Z=50.0) // left
    EntryRadius=500.0
    VehicleNameString="M45 Quadmount"
    HealthMax=101.0
    Health=101
    Mesh=SkeletalMesh'DH_M45_anm.m45_base_trailer'
    Skins(0)=texture'DH_Artillery_tex.m45.m45_trailer'
}
