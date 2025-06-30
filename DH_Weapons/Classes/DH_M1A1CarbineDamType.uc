//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1A1CarbineDamType extends DHMediumCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_M1CarbineWeapon'
    HUDIcon=Texture'InterfaceArt_tex.b792mm'
    KDamageImpulse=1500.0
    KDeathVel=110.0
    KDeathUpKick=2.0
}
