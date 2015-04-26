//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BrenWeapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bren_1st.ukx

defaultproperties
{
    NumMagsToResupply=2
    SightUpIronBringUp="Deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="deploy_reload_empty"
    SightUpMagPartialReloadAnim="deploy_reload_half"
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    FireModeClass(1)=class'DH_Weapons.DH_BrenMeleeFire'
    PickupClass=class'DH_Weapons.DH_BrenPickup'
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    ItemName="Bren Mk.IV"
    Mesh=SkeletalMesh'DH_Bren_1st.Bren'
}
