//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SVT38MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=155.0   // +15, SVT-38 had a longer bayonet
    FireRate=0.34 // +0.09
    DamageType=class'DH_Weapons.DH_SVT38BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_SVT38BayonetDamType'
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
