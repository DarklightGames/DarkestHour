//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM91MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=153.0   // +13 (~1600mm total length)
    FireRate=0.29 // +0.04
    DamageType=Class'DH_CarcanoM91BashDamType'
    BayonetDamageType=Class'DH_CarcanoM91BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
