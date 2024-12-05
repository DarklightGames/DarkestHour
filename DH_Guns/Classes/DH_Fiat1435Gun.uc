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
}
