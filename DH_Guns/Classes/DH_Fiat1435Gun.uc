//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat1435Gun extends DHATGun;

defaultproperties
{
    VehicleNameString="Fiat-Revelli Modello 14/35"
    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_TRIPOD_3RD'
    bCanBeRotated=true
    CollisionRadius=32.0
    CollisionHeight=32.0
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_Fiat1435MGPawn',WeaponBone=turret_placement)
    RotationsPerSecond=0.25
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'

    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
