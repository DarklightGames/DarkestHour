//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDDamType extends DHWeaponProjectileDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_PTRDWeapon'
    HUDIcon=texture'InterfaceArt_tex.deathicons.b762mm'

    VehicleDamageModifier=0.75
    TankDamageModifier=0.75
    APCDamageModifier=0.5
    TreadDamageModifier=0.5

    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    bThrowRagdoll=true
    GibModifier=4.0
    GibPerterbation=0.15
    KDamageImpulse=4500.0
    KDeathVel=200.0
    KDeathUpKick=25.0
    VehicleMomentumScaling=0.1
}
