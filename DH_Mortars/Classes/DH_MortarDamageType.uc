class DH_MortarDamageType extends ROWeaponDamageType
	abstract;

defaultproperties
{
     HUDIcon=Texture'InterfaceArt_tex.deathicons.artkill'
     TankDamageModifier=0.125000
     APCDamageModifier=0.500000
     VehicleDamageModifier=1.000000
     TreadDamageModifier=0.800000
     DeathString="%o was torn apart by a mortar shell."
     FemaleSuicide="%o was careless with her own mortar shell."
     MaleSuicide="%o was careless with his own mortar shell."
     bArmorStops=False
     bLocationalHit=False
     bDetonatesGoop=True
     bDelayedDamage=True
     bThrowRagdoll=True
     bExtraMomentumZ=True
     bFlaming=True
     GibModifier=4.000000
     DeathOverlayMaterial=Combiner'Effects_Tex.GoreDecals.PlayerDeathOverlay'
     DeathOverlayTime=999.000000
     GibPerterbation=0.150000
     KDamageImpulse=5000.000000
     KDeathVel=350.000000
     KDeathUpKick=250.000000
     KDeadLinZVelScale=0.001500
     KDeadAngVelScale=0.001500
     VehicleMomentumScaling=1.300000
     HumanObliterationThreshhold=400
}
