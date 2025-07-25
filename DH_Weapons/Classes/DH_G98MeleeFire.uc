//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_G98MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=154.0   // +14 (~1620mm total length)
    FireRate=0.29 // +0.04
    
    DamageType=Class'DH_G98BashDamType'
    BayonetDamageType=Class'DH_G98BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
