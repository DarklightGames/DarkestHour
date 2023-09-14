//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak39Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="5.0cm KwK 39 gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Pak39CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Pak39_anm.pak39_body'
    Skins(0)=Texture'DH_Pak39_tex.body.pak39_body'
    DestroyedVehicleMesh=StaticMesh'DH_Pak39_stc.Destroyed.pak39_destroyed'
    VehicleHudImage=Texture'DH_Pak39_tex.interface.pak39_body_hud'
    VehicleHudTurret=TexRotator'DH_Pak39_tex.interface.pak39_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Pak39_tex.interface.pak39_turret_look'
    ExitPositions(0)=(X=-115.00,Y=0.00,Z=60.00)
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_ATGun_Static'

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
