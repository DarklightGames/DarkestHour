//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435Gun extends DHMountedMachineGun
    abstract;

defaultproperties
{
    VehicleNameString="Fiat-Revelli modello 14/35"
    Mesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_TRIPOD_3RD'
    Skins(0)=Texture'DH_Fiat1435_tex.FIAT1435_3RD'
    CannonSkins(0)=Texture'DH_Fiat1435_tex.FIAT1435_3RD'
    bCanBeRotated=true
    CollisionRadius=36.0
    CollisionHeight=36.0
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Fiat1435MGPawn',WeaponBone=turret_placement)
    RotationsPerSecond=0.125
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mg_topdown'
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'
}
