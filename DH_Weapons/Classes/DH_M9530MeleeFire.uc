//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M9530MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=135.0   // -5 (~100mm less than kar98k)
    FireRate=0.23 // -0.02
    DamageType=class'DH_Weapons.DH_M9530BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_M9530BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
