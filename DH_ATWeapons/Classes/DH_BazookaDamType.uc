//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaDamType extends ROAntiTankProjectileDamType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.zookakill'
     TankDamageModifier=0.000000
     APCDamageModifier=0.250000
     VehicleDamageModifier=0.800000
     TreadDamageModifier=0.250000
     WeaponClass=Class'DH_ATWeapons.DH_BazookaWeapon'
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=150.000000
     KDeathUpKick=50.000000
     HumanObliterationThreshhold=400
}
