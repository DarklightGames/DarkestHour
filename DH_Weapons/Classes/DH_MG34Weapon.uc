//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34Weapon extends DHFastAutoWeapon;

// Modified to fix graphics bug where a Mac computer doesn't draw the specularity shader, leaving most of the 1st person weapon invisible to the user
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (PlatformIsMacOS())
    {
        Log("MG34 detected Mac OS & so switching weapon skin from specularity shader to standard diffuse texture"); // TEMPDEBUG
        Skins[2] = Texture'Weapons1st_tex.mg34';
    }
}

// Modified to make ironsights key try to deploy/undeploy the bipod (no iron sights for this weapon)
simulated function ROIronSights()
{
    Deploy();
}

// Overridden because we have no melee attack
// (this, apparently, is needed together with the mg34's single fire mode in order to avoid a bug where weapon breaks when emptied)
simulated function bool IsBusy()
{
    return false;
}

defaultproperties
{
    ItemName="MG 34"
    NativeItemName="Maschinengewehr 34"
    TeamIndex=0
    FireModeClass(0)=Class'DH_MG34AutoFire'
    FireModeClass(1)=Class'DH_MG34SemiAutoFire' // this secondary fire mode is not a switch, it is done with another button
    AttachmentClass=Class'DH_MG34Attachment'
    PickupClass=Class'DH_MG34Pickup'

    Mesh=SkeletalMesh'DH_Mg34_1st.MG34_Mesh'
    // Note - can't specify specularity shader as HighDetailOverlay as it doesn't work with the HDO system
    // Shader is fine when used as main weapon skin on its own, but when overlaid on top of standard texture (as the HDO is) it turns the weapon semi-transparent
    // It's because the shader uses the diffuse texture (which contains alpha transparency for the barrel shroud perforations) as an opacity mask
    // When overlaid on top of the standard texture, it appears the combination of an alpha texture used as an opacity mask creates this unwanted transparency
    Skins(2)=Shader'Weapons1st_tex.mg34_s'
    Skins(3)=Shader'Weapons1st_tex.MGBipod_S' // TODO: bipod specularity shader isn't used in the anim mesh & should be added there
    HandTex=Texture'Weapons1st_tex.hands_gergloves'

    PlayerIronsightFOV=90.0
    IronSightDisplayFOV=55.0
    //bCanFireFromHip=true
    FreeAimRotationSpeed=2.0

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
    NumMagsToResupply=1

    InitialBarrels=2
    BarrelClass=Class'DH_MG34Barrel'
    BarrelSteamBone="Barrel"
    BarrelChangeAnim="Bipod_Barrel_Change"
    
    bCanBipodDeploy=true
    bCanBeResupplied=true
    ZoomOutTime=0.1

    bMustReloadWithBipodDeployed=true
    
    IdleToBipodDeploy="hip_2_bipod"
    IdleToBipodDeployEmpty="hip_2_bipod"
    BipodDeployToIdle="bipod_2_hip"
    BipodIdleAnim="bipod_idle"
    BipodMagEmptyReloadAnim="bipod_reload_empty"
    BipodMagPartialReloadAnim="bipod_reload_empty"

    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="Sprint_End"
    IdleAnim="hip_Idle"
}
