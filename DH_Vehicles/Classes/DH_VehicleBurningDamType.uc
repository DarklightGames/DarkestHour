class DH_VehicleBurningDamType extends ROWeaponDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.VehicleFireKill'
     TankDamageModifier=1.000000
     APCDamageModifier=1.000000
     VehicleDamageModifier=1.000000
     DeathString="%o was burned up in his tank in a fire that %k started."
     FemaleSuicide="%o burned up in her tank."
     MaleSuicide="%o burned up in his tank."
     bArmorStops=false
     bLocationalHit=false
     bDetonatesGoop=true
     bDelayedDamage=true
     GibModifier=10.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuffLarge'
     KDamageImpulse=3000.000000
     KDeathVel=200.000000
     KDeathUpKick=300.000000
}
