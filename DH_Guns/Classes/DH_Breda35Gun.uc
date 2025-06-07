//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Fix view bounds (why is this not an issue on the pak guns?)
// [ ] setup gunsight camera bone system
// [ ] base mesh is missing top face
// [ ] view limits
// [ ] third & first person anims
// [ ] ammo, fire rates etc.
// [ ] ui art
// [ ] destroyed mesh
// [ ] finalized textures
// [ ] variants
//==============================================================================

class DH_Breda35Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="Breda mod. 35"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Breda35CannonPawn',WeaponBone="turret_placement")
    Mesh=SkeletalMesh'DH_Breda35_anm.breda35_body_ext'
    //Skins(0)=Texture'DH_Artillery_tex.Flak38.Flak38_gun'
    //DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.Flak38.Flak38_static_dest'
    //VehicleHudImage=Texture'DH_Artillery_tex.ATGun_Hud.flak38_body_static'
    //VehicleHudTurret=TexRotator'DH_Artillery_tex.ATGun_Hud.flak38_turret_rot'
    //VehicleHudTurretLook=TexRotator'DH_Artillery_tex.ATGun_Hud.flak38_turret_look'
    ExitPositions(1)=(X=-30.0,Y=70.0,Z=50.0)
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.aa_light'

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
    KParams=KParams0
}
