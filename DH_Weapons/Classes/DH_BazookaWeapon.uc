//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BazookaWeapon extends DHRocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bazooka_1st.ukx

defaultproperties
{
    RangeSettings(0)=(FirePitch=15,IronIdleAnim="Iron_idle",FireIronAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=850,IronIdleAnim="iron_idleMid",FireIronAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=2450,IronIdleAnim="iron_idleFar",FireIronAnim="iron_shootFar")
    FireModeClass(0)=class'DH_Weapons.DH_BazookaFire'
    FireModeClass(1)=class'DH_Weapons.DH_BazookaMeleeFire'
    PickupClass=class'DH_Weapons.DH_BazookaPickup'
    AttachmentClass=class'DH_Weapons.DH_BazookaAttachment'
    ItemName="M1A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka'
    FillAmmoMagCount=1
    bCanHaveAsssistedReload=true
    bDoesNotRetainLoadedMag=true
}
