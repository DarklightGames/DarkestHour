//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Bofors40mmGun extends DHATGun;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Artillery_stc.usx
#exec OBJ LOAD FILE=..\Animations\DH_Bofors_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Bofors_tex.utx

defaultproperties
{
    VehicleNameString="Bofors 40mm gun"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Bofors40mmCannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Bofors_anm.bofors_body'
    Skins(0)=texture'DH_Bofors_tex.bofors.bofors_01'
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_static_dest'
    VehicleHudImage=texture'DH_Bofors_tex.HUD.bofors_body'
    VehicleHudTurret=TexRotator'DH_Bofors_tex.HUD.bofors_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Bofors_tex.HUD.bofors_turret_look'
    VehicleHudOccupantsX(0)=0.5 // should be slightly to the right, but the red dot doesn't rotate with the cannon, so when traversed it would go wrong
    VehicleHudOccupantsX(1)=0.5
    ExitPositions(1)=(X=-30.0,Y=70.0,Z=50.0)
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-10.0) // relatively, COM is high, gun is light & it's base is not so stable, so any karma impulse can make it rock - this lowers COM to approx ground level
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Bofors40mmGun.KParams0'
}

