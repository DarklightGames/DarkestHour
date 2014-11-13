//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
     ProjectileDescriptions(1)="AP"
     ProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
     InitialPrimaryAmmo=25
     InitialSecondaryAmmo=13
     PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
     SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellAP'
     Mesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB'
}
