//=============================================================================
// DH_G41MeleeFire
//=============================================================================
// Melee firing for the G41
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_G41MeleeFire extends DHMeleeFire;

defaultproperties
{
     DamageType=Class'DH_Weapons.DH_G41BashDamType'
     TraceRange=75.000000
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BotRefireRate=0.250000
     aimerror=800.000000
}
