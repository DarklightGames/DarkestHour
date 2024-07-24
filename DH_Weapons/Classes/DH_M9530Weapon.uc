//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M9530Weapon extends DHBoltActionWeapon;
//Austrian 1930 modification of Mannlicher M95
//Meant for volkssturm loadouts
//8x56R ammo was non-standard for Germany, so this weapon cannot be resupplied
//Volkssturm roles with this weapon should have another resuppliable option, like G98 for example

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(61, false);
    }
}


defaultproperties
{
    ItemName="Mannlicher M95/30"
    NativeItemName="Gewehr M95/30"
    SwayModifyFactor=0.50  // -0.10

    FireModeClass(0)=class'DH_Weapons.DH_M9530Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M9530MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M9530Attachment'
    PickupClass=class'DH_Weapons.DH_M9530Pickup'

    Mesh=SkeletalMesh'DH_Mannlicher_1st.m9530_mesh'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=84.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
    bCanHaveInitialNumMagsChanged=false  //will always spawn with 3 clips no matter the munitions

    IronBringUpRest="iron_inrest"
    bCanResupplyWhenEmpty=false
    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    PreReloadAnim="reload_half_start"
    FullReloadAnim="reload"
    SingleReloadAnim="reload_half_middle"
    PostReloadAnim="reload_half_end"

    BoltHipLastAnim="bolt_clipfall"
    BoltIronLastAnim="iron_bolt_clipfall"
}
