//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SVT38MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=155.0   // +15, SVT-38 had a longer bayonet
    DamageType=class'DH_Weapons.DH_SVT38BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_SVT38BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
