//=============================================================================
// C96MeleeFire
//=============================================================================

class DH_C96MeleeFire extends DHMeleeFire;

defaultproperties
{
     DamageType=Class'DH_Weapons.DH_C96BashDamType'
     TraceRange=75.000000
     GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit_ground'
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BotRefireRate=0.250000
     aimerror=800.000000
}
