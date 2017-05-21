//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Pak43ATGun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Pak43_anm.ukx

defaultproperties
{
    VehicleNameString="8.8 cm Pak43/41 AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak43CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak43_anm.pak43_body'
    Skins(0)=texture'DH_Artillery_Tex.Pak43.pak43_nocamo_ext'
    Skins(1)=texture'DH_Artillery_Tex.Pak43.Pak43_wheel'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak43.Pak43_dest'
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.pak43_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak43_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-105.00,Y=-37.00,Z=28.00)
    VehicleMass=11.0

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.9)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=50.0
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak43ATGun.KParams0'
}
