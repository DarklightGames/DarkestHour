//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M5Gun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_M5Gun_anm.ukx

defaultproperties
{
    VehicleNameString="3-inch Gun M5"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_M5GunCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_M5Gun_anm.m5_body'
    Skins(0)=texture'DH_M5Gun_tex.m5.m5'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.m5.m5_destroyed'
    VehicleHudImage=texture'DH_M5Gun_tex.HUD.m5_body'
    VehicleHudTurret=TexRotator'DH_M5Gun_tex.HUD.m5_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M5Gun_tex.HUD.m5_turret_look'
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.6
    ExitPositions(0)=(X=-120.00,Y=-60.00,Z=65.00)
    ExitPositions(1)=(X=-120.00,Y=60.00,Z=65.00)
    ExitPositions(2)=(X=-165.00,Y=0.00,Z=65.00)
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_M5Gun.KParams0'
}
