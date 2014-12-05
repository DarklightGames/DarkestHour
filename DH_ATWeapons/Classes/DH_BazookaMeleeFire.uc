//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_ATWeapons.DH_BazookaBashDamType'
    TraceRange=75.000000
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    BotRefireRate=0.250000
    aimerror=800.000000
}
