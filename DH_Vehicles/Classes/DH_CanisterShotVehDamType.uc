//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanisterShotVehDamType extends ROVehicleDamageType
    abstract;

defaultproperties
{
     HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.canisterkill'
     VehicleDamageModifier=0.100000
     DeathString="%o's vehicle was filled with holes by %k's canister shot."
     FemaleSuicide="%o turned the gun on herself."
     MaleSuicide="%o turned the gun on himself."
     GibModifier=0.000000
     PawnDamageEmitter=Class'ROEffects.ROBloodPuff'
     KDamageImpulse=200.000000
}
