//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_UniversalCarrierMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'allies_carrier_anm.Carrier_mg_ext'
    Skins(0)=texture'Weapons3rd_tex.Soviet.dtmg_world'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    GunnerAttachmentBone="com_attachment"

    // Movement
    RotationsPerSecond=0.5
    MaxPositiveYaw=9000
    MaxNegativeYaw=-9000
    CustomPitchUpLimit=4000
    CustomPitchDownLimit=60000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialPrimaryAmmo=60
    NumMGMags=15
    FireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Tip"
    WeaponFireOffset=-8.0 // originally zero but flash was too far out in front of the muzzle
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleBrenMGEmitter' // originally used 'VehicleMGEmitterUC' but the ejected shell cases spill through the front of the vehicle
    FireSoundClass=sound'Inf_Weapons.dt_fire_loop'
    FireEndSound=sound'Inf_Weapons.dt.dt_fire_end'
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)

    // Reload
    HUDOverlayReloadAnim="Reload"
    ReloadStages(0)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)                    // TODO: sound is 1.76 duration vs 1.667 in anim notify (also below)
    ReloadStages(1)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65) // 2.29 / 2.333
    ReloadStages(2)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=2.35)                    // 2.35 / 2.333
    ReloadStages(3)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=3.2,HUDProportion=0.35)  // 4.04 / 3.267
}
