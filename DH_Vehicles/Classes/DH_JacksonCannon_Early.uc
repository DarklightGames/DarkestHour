//==============================================================================
// DH_JacksonCannon_Early
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer - 90mm cannon class - no HVAP
//==============================================================================
class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
     ProjectileDescriptions(1)="AP"
     ProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShell_Early'
     InitialPrimaryAmmo=25
     InitialSecondaryAmmo=13
     PrimaryProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShell_Early'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_JacksonCannonShellAP'
     Mesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB'
}
