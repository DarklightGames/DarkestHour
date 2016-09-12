//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'SVT40BashDamType'
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    TraceRange=75.0
    BotRefireRate=0.25
    AimError=800.0
}
