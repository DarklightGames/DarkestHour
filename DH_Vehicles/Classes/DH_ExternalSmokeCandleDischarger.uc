//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ExternalSmokeCandleDischarger extends DHVehicleSmokeLauncher;

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_GermanSmokeCandleProjectile'
    InitialAmmo=6
    ProjectilesPerFire=2
    FireSound=SoundGroup'DH_WeaponSounds.SmokeLaunchers.8cmFireSG'
    bCanBeReloaded=false
    bShowHUDInfo=false // no HUD info as these are external launchers & crew have no indication how many are remaining - they have to remember
    FireRotation(0)=(Pitch=7200,Yaw=1150)
    FireRotation(1)=(Pitch=7200,Yaw=-1150)
    FireRotation(2)=(Pitch=7500,Yaw=-5750)
    FireRotation(3)=(Pitch=7500,Yaw=5750)
    FireRotation(4)=(Pitch=7000,Yaw=-3450)
    FireRotation(5)=(Pitch=7000,Yaw=3450)
}
