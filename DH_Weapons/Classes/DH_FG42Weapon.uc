//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FG42Weapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Fallschirmgewehr42_1st.ukx

defaultproperties
{
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SightUpSelectFireIronAnim="deploy_switch_fire"
    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_FG42Fire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    PickupClass=class'DH_Weapons.DH_FG42Pickup'
    AttachmentClass=class'DH_Weapons.DH_FG42Attachment'
    ItemName="Fallschirmjägergewehr 42"
    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42'
}
