//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Flak88Gun extends DHATGun;

#exec OBJ LOAD FILE=..\Animations\DH_Flak88_anm.ukx
#exec OBJ LOAD FILE=..\Textures\MilitaryAxisSMT.utx
#exec OBJ LOAD FILE=..\StaticMeshes\MilitaryAxisSM.usx

defaultproperties
{
    VehicleNameString="8.8cm FlaK 36 gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak88CannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_Flak88_anm.flak88_base'
    Skins(0)=texture'MilitaryAxisSMT.Artillery.flak_88'
    DestroyedVehicleMesh=StaticMesh'MilitaryAxisSM.Artillery.Flak88_destroyed'
    VehicleHudImage=texture'DH_Artillery_Tex.ATGun_Hud.flak88_body'
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.flak88_turret_look'
    VehicleHudOccupantsX(1)=0.5 // should be slightly to the right, but the red dot doesn't rotate with the cannon, so when traversed it would go wrong
    VehicleHudOccupantsY(1)=0.5
    ExitPositions(1)=(X=-50.0,Y=50.0,Z=50.0)
    VehicleMass=20.0

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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Flak88Gun.KParams0'
}
