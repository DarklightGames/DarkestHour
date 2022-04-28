//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PanzerschreckWeapon extends DHRocketWeapon;

defaultproperties
{
    ItemName="Raketenpanzerbüchse 54"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_PanzerschreckFire'
    FireModeClass(1)=class'DH_Weapons.DH_PanzerschreckMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PanzerschreckAttachment'
    PickupClass=class'DH_Weapons.DH_PanzerschreckPickup'

    Mesh=SkeletalMesh'DH_Panzerschreck_1st.Panzerschreck'

    FillAmmoMagCount=1
    bDoesNotRetainLoadedMag=true
    bCanHaveAsssistedReload=true

    RangeSettings(0)=(FirePitch=0,IronIdleAnim="Iron_idle",FireIronAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=350,IronIdleAnim="iron_idleMid",FireIronAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=675,IronIdleAnim="iron_idleFar",FireIronAnim="iron_shootFar")
}
