//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_FG42Weapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Fallschirmgewehr42_1st.ukx

defaultproperties
{
    ItemName="Fallschirmjägergewehr 42"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_FG42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_FG42Attachment'
    PickupClass=class'DH_Weapons.DH_FG42Pickup'

    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42' // TODO: there is no specularity mask for this weapon

    IronSightDisplayFOV=28.0

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    bHasSelectFire=true

    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SightUpSelectFireIronAnim="deploy_switch_fire"
    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
}
