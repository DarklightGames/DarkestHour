//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_KorovinDamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_KorovinWeapon'
    HUDIcon=Texture'InterfaceArt_tex.b762mm'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
