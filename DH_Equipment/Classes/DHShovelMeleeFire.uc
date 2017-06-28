//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Equipment.DHShovelBashDamageType'
    TraceRange=75.0
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack" // TODO: this animation is incorrect, as it's the whole bash process - it needs to start from the 'bash_hold' position & end in the impact position
    BashFinishAnim="bash_return" // TODO: this animation is incorrect, as it should return from the impact position to the idle position (it's currently just an idle anim, without any return)
}
