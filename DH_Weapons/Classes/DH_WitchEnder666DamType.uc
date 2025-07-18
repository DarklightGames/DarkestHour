//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WitchEnder666DamType extends DHMediumCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=Class'DH_WitchEnder666Weapon'
    HUDIcon=Texture'DH_InterfaceArt_tex.canisterkill'
    KDamageImpulse=2500.0
    GibModifier=4.0
    PawnDamageEmitter=Class'DHBloodPuffLargeCaliber'
    
}
