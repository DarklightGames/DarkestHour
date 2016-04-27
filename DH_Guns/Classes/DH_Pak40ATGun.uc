//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Pak40ATGun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Pak40_anm.ukx

defaultproperties
{
    VehicleNameString="7.5cm Pak40 AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak40CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Pak40_anm.Pak40_body'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.RO_BC_pak40'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Pak40.pak40_destroyed'
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.Pak40_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(1)=(X=-84.00,Y=-27.00,Z=43.00)
    VehicleMass=11.0

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-2.0)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak40ATGun.KParams0'
}
