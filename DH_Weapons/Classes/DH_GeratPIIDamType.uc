//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GeratPIIDamType extends DHLargeCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_GeratPIIWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'

    TankDamageModifier=0.2
    APCDamageModifier=0.3
    VehicleDamageModifier=0.3
    TreadDamageModifier=0.3

    PawnDamageEmitter=class'DH_Effects.DHBloodPuffLargeCaliber'
    bThrowRagdoll=true
    GibModifier=4.0
    GibPerterbation=0.15
    KDamageImpulse=4500.0
    KDeathVel=200.0
    KDeathUpKick=25.0
    VehicleMomentumScaling=0.05
}
