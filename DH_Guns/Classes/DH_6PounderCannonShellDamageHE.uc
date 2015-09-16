//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_6PounderCannonShellDamageHE extends ROTankShellExplosionDamage
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.75
    KDeathVel=300.0
    KDeathUpKick=60.0
    KDeadLinZVelScale=0.002
    KDeadAngVelScale=0.003
    HumanObliterationThreshhold=200
}
