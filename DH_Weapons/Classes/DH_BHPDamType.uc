//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BHPDamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_BHPWeapon'
    HUDIcon=Texture'InterfaceArt_tex.b9mm'
    KDamageImpulse=750.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
