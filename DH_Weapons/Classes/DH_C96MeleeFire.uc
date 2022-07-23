//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_C96MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_C96BashDamType'
    GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit_ground'
    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"
}
