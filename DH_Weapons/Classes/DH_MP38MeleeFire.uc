//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MP38MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=Class'DH_MP38BashDamType'
    GroundBashSound=SoundGroup'Inf_Weapons_Foley.pistol_hit_ground'

    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="Bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"
}
