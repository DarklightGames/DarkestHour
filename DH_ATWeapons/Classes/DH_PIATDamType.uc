//=============================================================================
// DH_PIATDamType
//=============================================================================

class DH_PIATDamType extends ROAntiTankProjectileDamType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.piatkill'
     TankDamageModifier=0.030000
     APCDamageModifier=0.250000
     VehicleDamageModifier=0.800000
     TreadDamageModifier=0.250000
     WeaponClass=Class'DH_ATWeapons.DH_PIATWeapon'
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     KDeathVel=150.000000
     KDeathUpKick=50.000000
     HumanObliterationThreshhold=400
}
