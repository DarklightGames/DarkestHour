//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M1GarandMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_M1GarandBashDamType'
    BayonetDamageType=class'DH_Weapons.DH_M1GarandBayonetDamType'
    
    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"
    
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    //TO DO:
    //StabBackEmptyAnim="Stab_pullback_empty"
    //StabHoldEmptyAnim="Stab_hold_empty"
    //StabEmptyAnim="Stab_attack_empty"
    //StabFinishEmptyAnim="Stab_return_empty"
}
