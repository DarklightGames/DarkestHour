//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_Pak39Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="7.5cm PaK 39 gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak39CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Pak39_anm.pak39_body'
    Skins(0)=Texture'DH_Pak39_tex.body.pak39_body'
    //DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_static_dest'
    VehicleHudImage=Texture'DH_Artillery_tex.ATGun_Hud.flak38_body_static'
    VehicleHudTurret=TexRotator'DH_Artillery_tex.ATGun_Hud.flak38_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_tex.ATGun_Hud.flak38_turret_look'
    ExitPositions(1)=(X=-30.0,Y=70.0,Z=50.0)
    MapIconAttachmentClass=class'DHMapIconAttachment_ATGun_Rotating'

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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Pak39Gun.KParams0'
}
