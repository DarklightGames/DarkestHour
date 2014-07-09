//=============================================================================
// DH_Kar98MeleeFire
//=============================================================================
// Melee firing for the Kar98
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_Kar98MeleeFire extends ROMeleeFire;

defaultproperties
{
     DamageType=Class'DH_Weapons.DH_Kar98BashDamType'
     BayonetDamageType=Class'DH_Weapons.DH_Kar98BayonetDamType'
     TraceRange=75.000000
     BayonetTraceRange=125.000000
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BayoBackAnim="stab_pullback"
     BayoHoldAnim="stab_hold"
     BayoStabAnim="stab_attack"
     BayoFinishAnim="stab_return"
     BotRefireRate=0.250000
     aimerror=800.000000
}
