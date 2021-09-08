//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BazookaMeleeFire extends DHMeleeFire;

defaultproperties
{
    DamageType=class'DH_Weapons.DH_BazookaBashDamType'

    // Adjustment of bazooka melee speed (slower) for animation problem:
    FireRate=0.5
    MinHoldTime=0.3
    FullHeldTime=0.5
}
