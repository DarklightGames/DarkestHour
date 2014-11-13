//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ThompsonMeleeFire extends DHMeleeFire;

defaultproperties
{
     DamageType=class'DH_Weapons.DH_ThompsonBashDamType'
     TraceRange=75.000000
     GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit_ground'
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BotRefireRate=0.250000
     aimerror=800.000000
}
