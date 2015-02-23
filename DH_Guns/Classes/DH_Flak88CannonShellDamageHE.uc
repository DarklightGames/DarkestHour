//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak88CannonShellDamageHE extends ROTankShellExplosionDamage;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TankDamageModifier=0.08
    APCDamageModifier=0.5
    VehicleDamageModifier=1.5
    TreadDamageModifier=1.0
    DeathString="%o was ripped by shrapnel from %k's Flak 36 HE shell."
    FemaleSuicide="%o fired her Flak 36 HE shell prematurely."
    MaleSuicide="%o fired his Flak 36 HE shell prematurely."
    KDamageImpulse=6000.0
    KDeathVel=300.0
    KDeathUpKick=60.0
    VehicleMomentumScaling=1.6
    HumanObliterationThreshhold=450
}
