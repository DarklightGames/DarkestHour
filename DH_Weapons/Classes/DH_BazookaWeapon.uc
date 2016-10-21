//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bazooka_1st.ukx

defaultproperties
{
    ItemName="M1A1 Bazooka"
    FireModeClass(0)=class'DH_Weapons.DH_BazookaFire'
    FireModeClass(1)=class'DH_Weapons.DH_BazookaMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BazookaAttachment'
    PickupClass=class'DH_Weapons.DH_BazookaPickup'

    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka'
//  Skins(3)=shader'DH_Weapon_tex.Spec_Maps.BazookaShell_s'
//  HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.Bazooka_s' // these specularity shaders exist but weren't used in DH5.1 - perhaps because it doesn't look quite right
//  bUseHighDetailOverlayIndex=true
//  HighDetailOverlayIndex=2

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    RangeSettings(0)=(FirePitch=15,IronIdleAnim="Iron_idle",FireIronAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=850,IronIdleAnim="iron_idleMid",FireIronAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=2450,IronIdleAnim="iron_idleFar",FireIronAnim="iron_shootFar")
}
