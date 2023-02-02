//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StenMkVMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_StenMkVBashDamType'
    GroundBashSound=SoundGroup'Inf_Weapons_Foley.melee.pistol_hit_ground'

    BayonetTraceRange=120.0   // -20

    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"

    BashBackEmptyAnim="bash_pullback_empty"
    BashHoldEmptyAnim="bash_hold_empty"
    BashEmptyAnim="bash_attack_empty"
    BashFinishEmptyAnim="bash_return_empty"

    BayoBackEmptyAnim="stab_pullback_empty"
    BayoStabEmptyAnim="stab_attack_empty"
    BayoFinishEmptyAnim="stab_return_empty"
}
