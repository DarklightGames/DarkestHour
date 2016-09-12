//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDBulletShellDamageAP extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
    bArmorStops=true
    DeathString="%o was killed by %k's PTRD round."
    TankDamageModifier=0.75
    APCDamageModifier=0.50
    VehicleDamageModifier=0.75
    TreadDamageModifier=0.50
    VehicleMomentumScaling=0.05
    HumanObliterationThreshhold=500
    DeathOverlayMaterial=material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999.0
}
