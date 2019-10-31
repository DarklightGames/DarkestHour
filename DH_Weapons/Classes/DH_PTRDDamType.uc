//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PTRDDamType extends DHLargeCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_PTRDWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'

    VehicleDamageModifier=0.75
    TankDamageModifier=0.50
    APCDamageModifier=0.75
    TreadDamageModifier=0.5

    PawnDamageEmitter=class'ROEffects.ROBloodPuffLarge'
    bThrowRagdoll=true
    VehicleMomentumScaling=0.1
}
