//=============================================================================
// DH_EnfieldNo2MeleeFire
//=============================================================================

class DH_EnfieldNo2MeleeFire extends ROMeleeFire;

defaultproperties
{
     DamageType=Class'DH_Weapons.DH_EnfieldNo2BashDamType'
     TraceRange=75.000000
     GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit_ground'
     PlayerBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit'
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BashBackEmptyAnim="bash_pullback_empty"
     BashHoldEmptyAnim="bash_hold_empty"
     BashEmptyAnim="bash_attack_empty"
     BashFinishEmptyAnim="bash_return_empty"
     BotRefireRate=0.250000
     aimerror=800.000000
}
