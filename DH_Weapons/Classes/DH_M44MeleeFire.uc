//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M44MeleeFire extends DHMeleeFire;

defaultproperties
{
    FireRate=0.23 // -0.02
    BayonetDamageType=Class'DH_M44BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    BashBackAnim="" // bayonet is permanently attached so there are no bash anims
    BashHoldAnim=""
    BashAnim=""
    BashFinishAnim=""
}
