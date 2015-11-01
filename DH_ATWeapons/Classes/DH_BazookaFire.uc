//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BazookaFire extends DHRocketFire;

defaultproperties
{
    ExhaustLength=320.0
    ExhaustDamage=180.0
    ExhaustDamageType=class'DH_ATWeapons.DH_BazookaExhaustDamType'
    MuzzleBone="warhead1"
    AmmoClass=class'DH_ATWeapons.DH_BazookaAmmo'
    ProjectileClass=class'DH_ATWeapons.DH_BazookaRocket'
    Spread=400.0
}
