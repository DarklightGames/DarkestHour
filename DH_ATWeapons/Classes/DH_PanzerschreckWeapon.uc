//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerschreckWeapon extends DHRocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Panzerschreck_1st.ukx

defaultproperties
{
    RangeSettings(0)=(FirePitch=0,IronIdleAnim="Iron_idle",FireIronAnim="iron_shoot")
    RangeSettings(1)=(FirePitch=350,IronIdleAnim="iron_idleMid",FireIronAnim="iron_shootMid")
    RangeSettings(2)=(FirePitch=675,IronIdleAnim="iron_idleFar",FireIronAnim="iron_shootFar")
    FireModeClass(0)=class'DH_ATWeapons.DH_PanzerschreckFire'
    FireModeClass(1)=class'DH_ATWeapons.DH_PanzerschreckMeleeFire'
    PickupClass=class'DH_ATWeapons.DH_PanzerschreckPickup'
    AttachmentClass=class'DH_ATWeapons.DH_PanzerschreckAttachment'
    ItemName="Raketenpanzerbüchse 54"
    Mesh=SkeletalMesh'DH_Panzerschreck_1st.Panzerschreck'
    FillAmmoMagCount=1
    bCanHaveAsssistedReload=true
    bDoesNotRetainLoadedMag=true
}
