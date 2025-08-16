//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM9138CarbineMeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetTraceRange=130.0 // -10 (only ~150mm shorter than kar98k)
    FireRate=0.23 // -0.02
    DamageType=Class'DH_Weapons.DH_CarcanoM9138CarbineBashDamType'
    BayonetDamageType=Class'DH_Weapons.DH_CarcanoM9138CarbineBayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
}
