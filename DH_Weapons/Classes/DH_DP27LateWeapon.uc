//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_DP27LateWeapon extends DHFastAutoWeapon;

var name MagRotationBone;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // HACK: The DP27 is not rigged correctly and the bullet moves with the mag
    // rotation bone. Until this is fixed, we just hide the bullet for now.
    if (InstigatorIsLocallyControlled())
    {
        SetBoneScale(0, 0.0, 'Round');
    }
}

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

//=============================================================================
// Magazine Rotation
// 
// The DP-27 magazine rotates as rounds are expended from it.
//
// The DH_DP27Fire class explicitly calls UpdateMagRotation when a shot is
// fired to accomplish this.
//
// The magazine rotation also needs to be updated in other places, such as
// reload animations and when the gun is first brought up.
//=============================================================================

// Called from animation notifys to reset the mag rotation during a reload.
simulated event UpdateMagRotationMidReload()
{
    local int MagIndex;

    MagIndex = GetNextMagIndex();

    SetMagRotation(float(PrimaryAmmoArray[MagIndex]) / MaxAmmo(0));
}

// Updated the magazine rotation based on the number of rounds remaining in the magazine.
simulated function UpdateMagRotation()
{
    SetMagRotation(float(AmmoAmount(0)) / MaxAmmo(0));
}

// Sets the rotation of the magazine as a percentage of a full rotation (i.e., 0..1)
simulated function SetMagRotation(float Theta)
{
    local Rotator R;

    // We only want the magazine to spin around most of the way, not a full 360.
    Theta = class'UInterp'.static.Lerp(Theta, 1.0 / MaxAmmo(0), 1.0);
    R.Yaw = Class'UUnits'.static.RadiansToUnreal(Theta * Pi * 2);

    if (MagRotationBone != '')
    {
        SetBoneRotation(MagRotationBone, R);
    }
}

// Modified to update the magazine rotation.
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    UpdateMagRotation();
}

defaultproperties
{
    ItemName="DP-27 Machine Gun test"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_DP27LateFire'
    AttachmentClass=class'DH_Weapons.DH_DP27LateAttachment'
    PickupClass=class'DH_Weapons.DH_DP27LatePickup'

    Mesh=SkeletalMesh'DH_DP27_1st.DP27Late_1st'
    // Note - can't specify specularity shader as HighDetailOverlay as it doesn't work with the HDO system
    // Shader is fine when used as main weapon skin on its own, but when overlaid on top of standard texture (as the HDO is) it turns the weapon semi-transparent
    // It's because the shader uses the diffuse texture (which contains alpha transparency for the barrel shroud perforations) as an opacity mask
    // When overlaid on top of the standard texture, it appears the combination of an alpha texture used as an opacity mask creates this unwanted transparency
    Skins(2)=shader'Weapons1st_tex.MG.dp28_s'
    Skins(3)=Texture'DH_Weapon_tex.AlliedSmallArms.DP_extra'

    DisplayFOV=80.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    MaxNumPrimaryMags=4
    InitialNumPrimaryMags=4
    NumMagsToResupply=1
    bCanHaveInitialNumMagsChanged=false  //makes sense because carried ammo is primarily limited by "dead weight" of the pan magazines rather than ammo itself

    InitialBarrels=1  //to do: make barrel swap animation 
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

    MagRotationBone="MagRotation"
}
