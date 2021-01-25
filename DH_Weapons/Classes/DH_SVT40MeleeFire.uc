//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SVT40MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=147.0   // +7, SVT-40 was ~100mm longer than k98k
    DamageType=class'DH_Weapons.DH_SVT40BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_SVT40BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
