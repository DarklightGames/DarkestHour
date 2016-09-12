//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130MeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_MN9130BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_MN9130BayonetDamType'
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    TraceRange=75         // sets the attack range of the bash attack
    BayonetTraceRange=125 // sets the attack range of the bayonet attack
    BotRefireRate=0.25
    AimError=800
}
