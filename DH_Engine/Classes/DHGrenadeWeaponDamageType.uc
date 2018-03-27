//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGrenadeWeaponDamageType extends DHWeaponDamageType;

defaultproperties
{
    DeathString="%o was blown up by %k's %w."
    MaleSuicide="%o was blown up by his own %w."
    FemaleSuicide="%o was blown up by her own %w."

    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0

    GibModifier=1.5

    bDetonatesGoop=true
    bDelayedDamage=true
    bLocationalHit=false
    KDamageImpulse=2000
    KDeathVel=120
    KDeathUpKick=30
    bExtraMomentumZ=true

    KDeadLinZVelScale=0.005
    KDeadAngVelScale=0.0036

    TankDamageModifier=0.0
    APCDamageModifier=0.05 // Grenades will cause a little damage to APCs (the same modifier as the limited damage radius explosion of an impacting AP shell)
    VehicleDamageModifier=0.50
}
