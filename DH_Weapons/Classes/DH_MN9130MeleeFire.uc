//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MN9130MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=155.0   // +15 because 91/30 mosin with bayonet was significantly longer than other rifles
    FireRate=0.29 // +0.04
    DamageType=class'DH_Weapons.DH_MN9130BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_MN9130BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
