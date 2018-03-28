//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_SatchelDamType extends DHGrenadeWeaponDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_SatchelCharge10lb10sWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.satchel'

    VehicleDamageModifier=1.0
    APCDamageModifier=0.75  // was 1.0 in RO
    TankDamageModifier=0.4  // was 0.8 in DH 5.1 & was 1.0 in RO
    TreadDamageModifier=0.8 // was 1.0 in RO

    GibModifier=4.0
    KDamageImpulse=5000.0
    KDeathVel=300.0
    KDeathUpKick=75.0
    KDeadLinZVelScale=0.0015
    KDeadAngVelScale=0.0015
    HumanObliterationThreshhold=400
}
