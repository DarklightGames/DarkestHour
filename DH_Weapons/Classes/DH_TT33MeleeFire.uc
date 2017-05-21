//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_TT33MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_TT33BashDamType'
    BashBackAnim="bash_pullback"
    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldAnim="bash_hold"
    BashHoldEmptyAnim="bash_hold_empty"
    BashAnim="bash_attack"
    BashEmptyAnim="bash_attack_empty"
    BashFinishAnim="bash_return"
    BashFinishEmptyAnim="bash_return_empty"
    TraceRange=75.0
    GroundBashSound=sound'Inf_Weapons_Foley.melee.pistol_hit_ground'
    PlayerBashSound=sound'Inf_Weapons_Foley.melee.pistol_hit'
    BotRefireRate=0.25
    AimError=800.0
}
