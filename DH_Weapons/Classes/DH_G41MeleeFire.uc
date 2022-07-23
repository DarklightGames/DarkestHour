//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_G41MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_G41BashDamType'

    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"

    BayonetDamageType=class'DH_Weapons.DH_G41BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"

    BayoBackEmptyAnim="stab_pullback_empty"
    BayoStabEmptyAnim="stab_attack_empty"
    BayoFinishEmptyAnim="stab_return_empty"
}
