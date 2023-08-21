//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DT29Weapon extends DHFastAutoWeapon;

var name MagRotationBone;

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

defaultproperties
{
    ItemName="DT-29"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_DT29Fire'
    AttachmentClass=class'DH_Weapons.DH_DT29Attachment'
    PickupClass=class'DH_Weapons.DH_DT29Pickup'

    Mesh=SkeletalMesh'DH_DP27_1st.DT29_1st'
    // Note - can't specify specularity shader as HighDetailOverlay as it doesn't work with the HDO system
    // Shader is fine when used as main weapon skin on its own, but when overlaid on top of standard texture (as the HDO is) it turns the weapon semi-transparent
    // It's because the shader uses the diffuse texture (which contains alpha transparency for the barrel shroud perforations) as an opacity mask
    // When overlaid on top of the standard texture, it appears the combination of an alpha texture used as an opacity mask creates this unwanted transparency
    Skins(2)=Shader'Weapons1st_tex.MG.dtmg_s'

    DisplayFOV=80.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    MaxNumPrimaryMags=4
    InitialNumPrimaryMags=4
    NumMagsToResupply=1
    bCanHaveInitialNumMagsChanged=false  //makes sense because carried ammo is primarily limited by "dead weight" of the pan magazines rather than ammo itself

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_DT29Barrel'
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
    
    //IdleEmptyAnim="idle_empty"
    IdleToBipodDeployEmpty="deploy_empty"
    BipodDeployToIdleEmpty="undeploy_empty"
    BipodIdleEmptyAnim="deploy_idle_empty"

    //SprintStartEmptyAnim="sprint_start_empty"
    //SprintLoopEmptyAnim="sprint_middle_empty"
    //SprintEndEmptyAnim="sprint_end_empty"

    //CrawlStartEmptyAnim="crawl_in_empty"
    //CrawlEndEmptyAnim="crawl_out_empty"

    //SelectEmptyAnim="draw_empty"
    //PutDownEmptyAnim="putaway_empty"

    //MagRotationBone="MagRotation"
}
