//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DP27Weapon extends DHFastAutoWeapon;

// Modified to fix graphics bug where a Mac computer doesn't draw the specularity shader, leaving most of the 1st person weapon invisible to the user
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (PlatformIsMacOS())
    {
        Log("DP27 detected Mac OS & so switching weapon skin from specularity shader to standard diffuse texture"); // TEMPDEBUG
        Skins[2] = Texture'Weapons1st_tex.MG.DP28base';
    }
}

// Modified to make ironsights key try to deploy/undeploy the bipod (no iron sights for this weapon)
simulated function ROIronSights()
{
    Deploy();
}

// Modified to hide the bullet bone (see below).
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (InstigatorIsLocallyControlled())
    {
        // HACK: The DP27 is not rigged correctly and the bullet moves with the mag
        // rotation bone. Until this is fixed, we just hide the bullet for now.
        if (Level.NetMode != NM_DedicatedServer)
        {
            SetBoneScale(0, 0.0, 'Round');
        }
    }
}

defaultproperties
{
    ItemName="DP-27"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_DP27Fire'
    AttachmentClass=class'DH_Weapons.DH_DP27Attachment'
    PickupClass=class'DH_Weapons.DH_DP27Pickup'

    Mesh=SkeletalMesh'DH_DP27_1st.DP27_1st'
    // Note - can't specify specularity shader as HighDetailOverlay as it doesn't work with the HDO system
    // Shader is fine when used as main weapon skin on its own, but when overlaid on top of standard texture (as the HDO is) it turns the weapon semi-transparent
    // It's because the shader uses the diffuse texture (which contains alpha transparency for the barrel shroud perforations) as an opacity mask
    // When overlaid on top of the standard texture, it appears the combination of an alpha texture used as an opacity mask creates this unwanted transparency
    Skins(2)=Shader'Weapons1st_tex.MG.dp28_s'
    Skins(3)=Texture'DH_Weapon_tex.AlliedSmallArms.DP_extra'

    DisplayFOV=80.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    MaxNumPrimaryMags=4
    InitialNumPrimaryMags=4
    NumMagsToResupply=1
    bCanHaveInitialNumMagsChanged=false  //makes sense because carried ammo is primarily limited by "dead weight" of the pan magazines rather than ammo itself

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_DP27Barrel'
    BarrelSteamBone="bipod"
    
    bPlusOneLoading=false
    
    bCanBipodDeploy=true
    bCanBeResupplied=true
    ZoomOutTime=0.1

    bMustReloadWithBipodDeployed=true
    
    IdleToBipodDeploy="deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="reload_empty"
    BipodMagPartialReloadAnim="reload_half"
    
    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="Sprint_End"
    IdleAnim="Idle"
    PutDownAnim="Putaway"
    
    IdleEmptyAnim="idle_empty"
    IdleToBipodDeployEmpty="deploy_empty"
    BipodDeployToIdleEmpty="undeploy_empty"
    BipodIdleEmptyAnim="deploy_idle_empty"

    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownEmptyAnim="putaway_empty"

    WeaponComponentAnimations(0)=(DriverType=DRIVER_MagazineAmmunition,Channel=2,Animation="DP27MagRotation",BoneName="MagRotation")
}
