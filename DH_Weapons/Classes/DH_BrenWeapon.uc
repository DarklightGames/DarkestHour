//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BrenWeapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bren_1st.ukx

// Modified to play the click sound that would usually be played in the select animation (we don't have a select anim for the Bren)
simulated function ToggleFireMode()
{
    super.ToggleFireMode();

    PlaySound(sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01',, 2.0);
}

defaultproperties
{
    ItemName="Bren Mk.IV"
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    FireModeClass(1)=class'DH_Weapons.DH_BrenMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    PickupClass=class'DH_Weapons.DH_BrenPickup'

    Mesh=SkeletalMesh'DH_Bren_1st.Bren'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.BrenGun_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=30.0

    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    bCanBeResupplied=true
    NumMagsToResupply=2
    bHasSelectFire=true

    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
}
