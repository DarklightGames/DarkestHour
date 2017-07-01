//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Flak38Gun_Trailer extends DH_Flak38Gun;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Flak38CannonPawn_Trailer')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_trailer_dest'
    VehicleHudImage=texture'DH_Artillery_tex.ATGun_Hud.flak38_body_trailer'
    ExitPositions(1)=(X=-30.0,Y=85.0,Z=50.0)
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_trailer'
    Skins(1)=texture'DH_Artillery_tex.Flak38.Flak38_trailer'

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-30.0) // centre of mass sits much higher in the trailer version, so needs a bigger offset to keep COM at approx ground level
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
    KParams=KarmaParamsRBFull'DH_Guns.DH_Flak38Gun_Trailer.KParams0'
}
