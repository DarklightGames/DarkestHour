//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_DP28Weapon extends DHMGWeapon;

// Modified to fix graphics bug where a Mac computer doesn't draw the specularity shader, leaving most of the 1st person weapon invisible to the user
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (PlatformIsMacOS())
    {
        Log("DP28 detected Mac OS & so switching weapon skin from specularity shader to standard diffuse texture"); // TEMPDEBUG
        Skins[2] = Texture'Weapons1st_tex.MG.DP28base';
    }
}

defaultproperties
{
    ItemName="DP27 Machine Gun"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_DP28Fire'
    AttachmentClass=class'DH_Weapons.DH_DP28Attachment'
    PickupClass=class'DH_Weapons.DH_DP28Pickup'

    Mesh=SkeletalMesh'Allies_Dp28_1st.DP28_Mesh'
    // Note - can't specify specularity shader as HighDetailOverlay as it doesn't work with the HDO system
    // Shader is fine when used as main weapon skin on its own, but when overlaid on top of standard texture (as the HDO is) it turns the weapon semi-transparent
    // It's because the shader uses the diffuse texture (which contains alpha transparency for the barrel shroud perforations) as an opacity mask
    // When overlaid on top of the standard texture, it appears the combination of an alpha texture used as an opacity mask creates this unwanted transparency
    Skins(2)=shader'Weapons1st_tex.MG.dp28_s'

    PlayerIronsightFOV=90.0
    IronSightDisplayFOV=45.0
    bCanFireFromHip=true

    MaxNumPrimaryMags=4
    InitialNumPrimaryMags=4
    NumMagsToResupply=1
    bCanHaveInitialNumMagsChanged=false  //makes sense because carried ammo is primarily limited by "dead weight" of the pan magazines rather than ammo itself

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_DP28Barrel'
    BarrelSteamBone="bipod"

    IronBringUp="Rest_2_Hipped"
    IronPutDown="Hip_2_Rest"
    BipodHipIdle="Hip_Idle"
    BipodHipToDeploy="Hip_2_Bipod"
    MagEmptyReloadAnims(0)="Bipod_Reload"
    MagPartialReloadAnims(0)="Bipod_Reload_Half"
}
