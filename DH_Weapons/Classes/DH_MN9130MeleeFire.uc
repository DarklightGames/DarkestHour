//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=155.0   // +15 because 91/30 mosin with bayonet was significantly longer than other rifles
    FireRate=0.29 // +0.04
    DamageType=Class'DH_MN9130BashDamType'
    BayonetDamageType=Class'DH_MN9130BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
