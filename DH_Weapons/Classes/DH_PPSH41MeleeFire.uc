//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PPSh41MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=Class'DH_PPSH41BashDamType'
    GroundBashSound=SoundGroup'Inf_Weapons_Foley.pistol_hit_ground'
    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"
}
