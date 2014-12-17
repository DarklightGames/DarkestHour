//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHATMineDamage extends ROTankShellExplosionDamage
      abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.mine'
    TankDamageModifier=0.150000
    APCDamageModifier=0.500000
    VehicleDamageModifier=0.850000
    TreadDamageModifier=1.000000
    DeathString="%o was ripped apart by an anti-tank mine."
    bLocationalHit=true
    KDeathVel=300.000000
    KDeathUpKick=100.000000
    KDeadLinZVelScale=0.002000
    KDeadAngVelScale=0.003000
    HumanObliterationThreshhold=265
}
