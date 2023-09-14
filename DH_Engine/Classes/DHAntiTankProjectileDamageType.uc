//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAntiTankProjectileDamageType extends ROAntiTankProjectileDamType
    abstract;

defaultproperties
{
    TankDamageModifier=0.03
    APCDamageModifier=0.25
    VehicleDamageModifier=0.8
    TreadDamageModifier=0.25
    DeathString="%o was blown up by %k's %w."
    MaleSuicide="%o was blown up by his own %w."
    FemaleSuicide="%o was blown up by her own %w."
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    KDeathVel=150.0
    KDeathUpKick=50.0
    HumanObliterationThreshhold=400
}
