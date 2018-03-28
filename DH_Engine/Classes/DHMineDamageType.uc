//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMineDamageType extends DHDamageType
    abstract;

defaultproperties
{
    DeathString="%o was killed by a mine."
    MaleSuicide="%o was killed by a mine."
    FemaleSuicide="%o was killed by a mine."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.mine'

    bLocationalHit=false;
    KDamageImpulse=8000
    KDeathUpKick=100
    bArmorStops=false

    TankDamageModifier=1.0
    APCDamageModifier=1.0
    VehicleDamageModifier=1.10
    TreadDamageModifier=1.0
}
