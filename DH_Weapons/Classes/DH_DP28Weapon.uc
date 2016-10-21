//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28Weapon extends DHMGWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Dp28_1st.ukx

defaultproperties
{
    ItemName="DP28 Machine Gun"
    FireModeClass(0)=class'DH_Weapons.DH_DP28Fire'
    AttachmentClass=class'DH_Weapons.DH_DP28Attachment'
    PickupClass=class'DH_Weapons.DH_DP28Pickup'

    Mesh=SkeletalMesh'Allies_Dp28_1st.DP28_Mesh'
    Skins(2)=shader'Weapons1st_tex.MG.dp28_s' // can't specify specularity shader as HighDetailOverlay as includes opacity mask, which doesn't seem to work with HDO system

    PlayerIronsightFOV=90.0
    IronSightDisplayFOV=45.0
    bCanFireFromHip=true

    MaxNumPrimaryMags=4
    InitialNumPrimaryMags=4
    NumMagsToResupply=1 // TODO: seems a low resupply

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_DP28Barrel'
    BarrelSteamBone="bipod"

    IronBringUp="Rest_2_Hipped"
    IronPutDown="Hip_2_Rest"
    BipodHipIdle="Hip_Idle"
    BipodHipToDeploy="Hip_2_Bipod"
    MagEmptyReloadAnim="Bipod_Reload"
    MagPartialReloadAnim="Bipod_Reload_Half"
}
