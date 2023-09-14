//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ExternalSmokeCandleDischarger extends DHVehicleSmokeLauncher;

defaultproperties
{
    ProjectileClass=class'DH_Vehicles.DH_GermanSmokeCandleProjectile'
    InitialAmmo=6
    ProjectilesPerFire=2
    FireSound=SoundGroup'DH_WeaponSounds.SmokeLaunchers.8cmFireSG'
    bCanBeReloaded=false
    //**for game play reasons, we are going to activate the ammo counter on the HUD, even though the below reason for not showing it is valid**
    //bShowHUDInfo=false // no HUD info as these are external launchers & crew have no indication how many are remaining - they have to remember
    HUDAmmoIcon=Texture'DH_InterfaceArt_tex.Tank_Hud.SmokeCandle_PLACEHOLDER' // TODO: get ammo & reload icons made to replace these placeholders
    HUDAmmoReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.SmokeCandle_reload_PLACEHOLDER'
    FireRotation(0)=(Pitch=7200,Yaw=1150)
    FireRotation(1)=(Pitch=7200,Yaw=-1150)
    FireRotation(2)=(Pitch=7500,Yaw=-5750)
    FireRotation(3)=(Pitch=7500,Yaw=5750)
    FireRotation(4)=(Pitch=7000,Yaw=-3450)
    FireRotation(5)=(Pitch=7000,Yaw=3450)
}
