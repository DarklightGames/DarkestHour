//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarDamageType extends ROWeaponDamageType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt_tex.deathicons.artkill'
    TankDamageModifier=0.125
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.8
    DeathString="%o was torn apart by a mortar shell."
    FemaleSuicide="%o was careless with her own mortar shell."
    MaleSuicide="%o was careless with his own mortar shell."
    bLocationalHit=false
    bDetonatesGoop=true
    bDelayedDamage=true
    bThrowRagdoll=true
    bExtraMomentumZ=true
    bFlaming=true
    GibModifier=4.0
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    GibPerterbation=0.15
    KDamageImpulse=5000.0
    KDeathVel=350.0
    KDeathUpKick=250.0
    KDeadLinZVelScale=0.0015
    KDeadAngVelScale=0.0015
    VehicleMomentumScaling=1.3
    HumanObliterationThreshhold=400
}
