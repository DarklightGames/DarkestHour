//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MKB42HMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=Class'DH_MKB42HBashDamType'
    
    BayonetTraceRange=130.0   // -10

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
