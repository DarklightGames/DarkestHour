//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This weapon goes by many names:
// - Wz. 35
// - Panzerbüchse Modell 1935
// - Fucile Controcarro 35(p)
//
// It is a Polish anti-tank rifle that was used by the Germans after the invasion
// of Poland, where it was captured in large numbers.
//
// The Germans gave around 630 of these rifles to the Italians, who used them
// under the designation "Fucile Controcarro 35(p)".
//
// The Germans upgraded the projectile by reloading it with a tungsten core. This
// increased the muzzle velocity to 1295 m/s. This allegedly boosted the penetration,
// but we've found no numbers to back this up. Therefore, we're using the penetration
// values we've found for the standard round.
//
// Sources:
// [1] https://www.tankarchives.ca/2018/09/karabin-wz-35-secret-weapon-of.html
//==============================================================================

class DH_Wz35Weapon extends DHBoltActionWeapon;

// Modified to make ironsights key try to deploy/undeploy the bipod
simulated function ROIronSights()
{
    Deploy();
}

// HACK: Bypass special reload logic in `DHBoltActionWeapon` to fix the issues with reloading.
function PerformReload(optional int Count)
{
    super(DHProjectileWeapon).PerformReload(Count);
}

simulated function ClientDoReload(optional byte NumRounds)
{
    super(DHProjectileWeapon).ClientDoReload(NumRounds);
}

function ServerRequestReload()
{
    super(DHProjectileWeapon).ServerRequestReload();
}

simulated function byte GetRoundsToLoad()
{
    if (CurrentMagCount == 0)
    {
        return 0;
    }

    return GetMaxLoadedRounds();
}

simulated function int GetStripperClipSize()
{
    return 4;
}

defaultproperties
{
    ItemName="Fucile Controcarro 35(P)"
    FireModeClass(0)=class'DH_Weapons.DH_Wz35Fire'
    AttachmentClass=class'DH_Weapons.DH_Wz35Attachment'
    PickupClass=class'DH_Weapons.DH_Wz35Pickup'

    Mesh=SkeletalMesh'DH_Wz35_anm.wz35_1st'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=55

    bCanHaveInitialNumMagsChanged=false
    bUsesMagazines=true
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6

    bCanBipodDeploy=true
    bCanRestDeploy=false
    bCanFireFromHip=false
    bMustReloadWithBipodDeployed=true
    bMustFireWhileSighted=true

    SelectAnim="draw"
    PutDownAnim="putaway"
    IdleToBipodDeploy="bipod_in"
    BipodDeployToIdle="bipod_out"
    BoltIronAnim="iron_bolt"
    BipodIdleAnim="iron_idle"
    BipodMagEmptyReloadAnim="reload_empty"
    BipodMagPartialReloadAnim="reload_empty"
    MagEmptyReloadAnims(0)="reload_empty"

    bShouldZoomWhenBolting=true
    bMustBeDeployedToBolt=true
}
