//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M3GunCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M3AT_anm.gun'
    Skins(0)=Texture'DH_M3AT_tex.gun.M3_Light_AT_Gun'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.M5.M5_gun_collision' // TODO: replace
    bAttachColMeshToPitchBone=true // because the gun shield also tilts back & forth when the gun is elevated // TODO: but query whether shield should move (pretty sure not)
    GunnerAttachmentBone="com_player"

    WeaponAttachOffset=(X=0,Y=0,Z=-15)

    // Turret movement
    MaxPositiveYaw=4096 // 22.5 degrees traverse (traverse seems a little too high, shield clips through the gun base slightly)
    MaxNegativeYaw=-4096
    YawStartConstraint=-4500
    YawEndConstraint=4500
    CustomPitchUpLimit=5460 // 30/-5 degrees elevation/depression
    CustomPitchDownLimit=64625

    ProjectileClass=class'DH_Vehicles.DH_StuartCannonShell' // Check if Stuart shells are correct, Pak 40 for instance used longer shells than the tank equivalent of the gun)
    PrimaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_StuartCannonShellHE'
    TertiaryProjectileClass=class'DH_Engine.DHCannonShellCanister'

    ProjectileDescriptions(2)="Canister"

    nProjectileDescriptions(0)="M51B1 APC"
    nProjectileDescriptions(1)="M63 HE-T"
    nProjectileDescriptions(2)="M2 Canister"

    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=30
    InitialTertiaryAmmo=15

    MaxPrimaryAmmo=64
    MaxSecondaryAmmo=44
    MaxTertiaryAmmo=20

	Spread=0.0016
    SecondarySpread=0.0016
    TertiarySpread=0.04


    // Weapon fire
    WeaponFireOffset=10.0
    AddedPitch=20

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01' // Change sounds
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //~3.9 seconds reload (probably make reload faster)
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')
}
