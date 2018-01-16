//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_45mmM1937Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="45mm M1937 AT gun **WIP**"
    VehicleTeam=1
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_45mmM1937GunCannonPawn',WeaponBone="Turret_placement")
    Mesh=SkeletalMesh'DH_45mm_anm.45mmM1937_base'
    Skins(0)=Texture'allies_ahz_guns_tex.45mm.45mm_ext'
    DestroyedVehicleMesh=StaticMesh'allies_ahz_guns_stc.45mm.45mm_destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_Artillery_tex.45mmATGun.45mmATGun_dest'
    VehicleHudImage=Texture'DH_Artillery_Tex.ATGun_Hud.45mmATGun_body'
    VehicleHudTurret=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.45mm_ATGun_gun_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.45mm_ATGun_gun_look'
    VehicleHudOccupantsX(1)=0.44
    VehicleHudOccupantsY(1)=0.62
    ExitPositions(1)=(X=-30.0,Y=-13.0,Z=25.0)
    VehicleMass=8.0
    SupplyCost=600

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.4,Y=0.0,Z=-0.3) // default is zero
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_45mmM1937Gun.KParams0'
}
