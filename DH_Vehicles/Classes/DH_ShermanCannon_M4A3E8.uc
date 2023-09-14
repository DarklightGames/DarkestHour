//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannon_M4A3E8 extends DH_ShermanCannonA_76mm;

defaultproperties
{
    Mesh=SkeletalMesh'DH_ShermanM4A3E8_anm.turret_ext'
    Skins(0)=Texture'DH_ShermanM4A3E8_tex.turret2_ext'
    Skins(1)=FinalBlend'DH_ShermanM4A3E8_tex.body_int_fb'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.Turret.turret_collision')

    WeaponFireAttachmentBone="muzzle"

    // Coaxial MG
    AltFireAttachmentBone="coax"
    AltFireOffset=(X=-8,Y=0,Z=0)
    AltFireSpawnOffsetX=0.0

    // Projectiles
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellSmoke'

    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=13
    InitialTertiaryAmmo=2
    MaxPrimaryAmmo=43
    MaxSecondaryAmmo=26
    MaxTertiaryAmmo=2
    SecondarySpread=0.00135
    TertiarySpread=0.001

    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="M62 APC"
    nProjectileDescriptions(1)="M42 HE"
    nProjectileDescriptions(2)="M88 HC"

    FireAttachBone="com_attachment"
    FireEffectOffset=(X=0,Y=0,Z=50)
}

