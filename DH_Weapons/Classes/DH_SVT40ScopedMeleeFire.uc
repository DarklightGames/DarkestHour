//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedMeleeFire extends DHMeleeFire;

defaultproperties
{
// RO Variables
    DamageType = class'SVT40BashDamType'

    BashBackAnim = bash_pullback
    BashHoldAnim = bash_hold
    BashAnim = bash_attack
    BashFinishAnim = bash_return

    TraceRange = 75             // Sets the attack range of the bash attack

// UT Variables
    BotRefireRate=0.25
    AimError=800
}
