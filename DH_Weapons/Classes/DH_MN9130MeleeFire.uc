//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130MeleeFire extends DHMeleeFire;

defaultproperties
{
// RO Variables
    DamageType = class'DH_Weapons.DH_MN9130BashDamType'
    BayonetDamageType = class'DH_Weapons.DH_MN9130BayonetDamType'

    BashBackAnim = bash_pullback
    BashHoldAnim = bash_hold
    BashAnim = bash_attack
    BashFinishAnim = bash_return
    BayoBackAnim = stab_pullback
    BayoHoldAnim = stab_hold
    BayoStabAnim = stab_attack
    BayoFinishAnim = stab_return

    TraceRange = 75             // Sets the attack range of the bash attack
    BayonetTraceRange = 125   // Sets the attack range of the bayonet attack

// UT Variables
    BotRefireRate=0.25
    AimError=800
}