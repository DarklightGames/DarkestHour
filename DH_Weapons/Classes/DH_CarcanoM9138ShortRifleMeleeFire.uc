//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM9138ShortRifleMeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=153.0   // +13 (~1600mm total length)
    FireRate=0.29 // +0.04
    DamageType=Class'DH_Weapons.DH_CarcanoM9138ShortRifleBashDamType'
    BayonetDamageType=Class'DH_Weapons.DH_CarcanoM9138ShortRifleBayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
