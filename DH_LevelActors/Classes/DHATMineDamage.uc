//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHATMineDamage extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'
    TankDamageModifier=0.15
    APCDamageModifier=0.5
    VehicleDamageModifier=0.85
    TreadDamageModifier=1.0
    DeathString="%o was ripped apart by an anti-tank mine."
    bLocationalHit=true
    KDeathVel=300.0
    KDeathUpKick=100.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=265
}
