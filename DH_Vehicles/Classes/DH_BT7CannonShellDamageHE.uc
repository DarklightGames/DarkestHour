//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7CannonShellDamageHE extends DHShellHE50mmDamageType;

defaultproperties
{
    TankDamageModifier=0.0
    APCDamageModifier=0.5
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.75
    KDeathVel=300.000000
    KDeathUpKick=60.000000
    KDeadLinZVelScale=0.002000
    KDeadAngVelScale=0.003000
    HumanObliterationThreshhold=200
    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
    bArmorStops=true
    VehicleMomentumScaling=1.3
}
