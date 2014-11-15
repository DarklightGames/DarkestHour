//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaFire extends DH_RocketFire;

defaultproperties
{
    FireIronAnims(0)="iron_shoot"
    FireIronAnims(1)="iron_shootMid"
    FireIronAnims(2)="iron_shootFar"
    ExhaustDamageType=class'DH_ATWeapons.DH_BazookaExhaustDamType'
    MuzzleBone="warhead1"  //TODO: not right, find the right one
    AmmoClass=class'DH_ATWeapons.DH_BazookaAmmo'
    ProjectileClass=class'DH_ATWeapons.DH_BazookaRocket'
}

