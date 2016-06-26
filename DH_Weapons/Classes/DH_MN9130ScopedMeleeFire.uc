//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130ScopedMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_MN9130ScopedBashDamType'
    BashBackAnim=bash_pullback
    BashHoldAnim=bash_hold
    BashAnim=bash_attack
    BashFinishAnim=bash_return
    TraceRange=75
    BotRefireRate=0.25
    AimError=800
}
