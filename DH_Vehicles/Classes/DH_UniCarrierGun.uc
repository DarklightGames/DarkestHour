//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_UniCarrierGun extends UniCarrierGun;

// Play the reload animation on the client
simulated function ClientDoReload()
{
    if (Owner != none && VehicleWeaponPawn(Owner) != none && VehicleWeaponPawn(Owner).HUDOverlay != none)
        VehicleWeaponPawn(Owner).HUDOverlay.PlayAnim('reload_empty'); //'Reload'
}

defaultproperties
{
    NumMags=20
    ReloadLength=7.000000
    DummyTracerClass=class'DH_Vehicles.DH_BrenVehicleClientTracer'
    mTracerInterval=0.600000
    hudAltAmmoIcon=texture'DH_InterfaceArt_tex.weapon_icons.Bren_ammo'
    YawBone="Gun_protection"
    PitchBone="Gun_protection"
    RotationsPerSecond=0.500000
    Spread=0.002000
    FireInterval=0.125000
    AltFireInterval=0.125000
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleBrenMGEmitter'
    FireSoundClass=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_loop'
    AmbientSoundScaling=5.000000
    FireEndSound=SoundGroup'Inf_Weapons.dp1927.dp1927_fire_end'
    ProjectileClass=class'DH_Vehicles.DH_BrenVehicleBullet'
    ShakeRotRate=(X=50.000000,Y=50.000000,Z=50.000000)
    ShakeOffsetRate=(X=5.000000,Y=5.000000,Z=5.000000)
    CustomPitchUpLimit=3500
    CustomPitchDownLimit=63000
    MaxPositiveYaw=7500
    MaxNegativeYaw=-7000
    InitialPrimaryAmmo=30
    Mesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_ext'
}
