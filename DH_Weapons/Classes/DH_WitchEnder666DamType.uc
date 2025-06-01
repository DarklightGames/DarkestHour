//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WitchEnder666DamType extends DHMediumCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_WitchEnder666Weapon'
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.canisterkill'
    KDamageImpulse=2500.0
    GibModifier=4.0
    PawnDamageEmitter=class'DH_Effects.DHBloodPuffLargeCaliber'
    
}
