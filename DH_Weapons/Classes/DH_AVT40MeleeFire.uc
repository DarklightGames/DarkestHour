//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AVT40MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=147.0   // +7, SVT-40 was ~100mm longer than k98k
    FireRate=0.29 // +0.04
    DamageType=Class'DH_AVT40BashDamType'
    BayonetDamageType=Class'DH_AVT40BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"

    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"

    BayoBackEmptyAnim="stab_pullback_empty"
    BayoStabEmptyAnim="stab_attack_empty"
    BayoFinishEmptyAnim="stab_return_empty"
}
