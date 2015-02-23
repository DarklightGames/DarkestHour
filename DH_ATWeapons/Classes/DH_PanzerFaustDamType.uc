//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustDamType extends ROAntiTankProjectileDamType
    abstract;

defaultproperties
{
    HUDIcon=texture'InterfaceArt2_tex.deathicons.faustkill'
    TankDamageModifier=0.03
    APCDamageModifier=0.25
    VehicleDamageModifier=0.8
    TreadDamageModifier=0.25
    WeaponClass=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
    DeathOverlayTime=999.0
    KDeathVel=150.0
    KDeathUpKick=50.0
}
