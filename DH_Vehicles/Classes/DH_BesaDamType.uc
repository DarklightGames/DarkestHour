//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BesaDamType extends DHMediumCaliberDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b792mm'
    WeaponClass=class'DH_Weapons.DH_30calWeapon' // BESA is vehicle-mounted only, so doesn't have corresponding WeaponClass in DH_Weapons - nevermind, we just add its name to death strings below
    KDamageImpulse=2250.0
}
