//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FG42Weapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Fallschirmgewehr42_1st.ukx

defaultproperties
{
    ItemName="Fallschirmjägergewehr 42"
    FireModeClass(0)=class'DH_Weapons.DH_FG42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_FG42Attachment'
    PickupClass=class'DH_Weapons.DH_FG42Pickup'

    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42' // TODO: there is no specularity mask for this weapon

    IronSightDisplayFOV=35.0

    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    NumMagsToResupply=2 // TODO: can't be resupplied (needs bCanBeResupplied=true) - one or the other (if should be resupplied, move 2 def props to bipod auto parent class)
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
