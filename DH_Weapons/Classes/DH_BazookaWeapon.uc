//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="M1A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka'
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BazookaFire'
    FireModeClass(1)=class'DH_Weapons.DH_BazookaMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BazookaAttachment'
    PickupClass=class'DH_Weapons.DH_BazookaPickup'

    // These specularity shaders exist (for weapon & rocket) but weren't used in DH5.1 - perhaps because they don't look quite right
    // The shine on bare metal parts looms good, but the green painted metal looks more like frost:
//  Skins(3)=shader'DH_Weapon_tex.Spec_Maps.BazookaShell_s'
//  HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.Bazooka_s'
//  bUseHighDetailOverlayIndex=true
//  HighDetailOverlayIndex=2

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    //Anims

    // Rates
    SelectAnimRate=0.5
    PutDownAnimRate=1.0

    SelectAnim=Draw
    PutDownAnim=putaway

    RangeSettings(0)=(FirePitch=15,IronIdleAnim="Iron_idle",IronFireAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=850,IronIdleAnim="iron_idleMid",IronFireAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=2450,IronIdleAnim="iron_idleFar",IronFireAnim="iron_shootFar")
}
