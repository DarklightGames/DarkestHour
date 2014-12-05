//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadeWeapon extends DH_GrenadeWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_M1Grenade_1st.ukx

defaultproperties
{
    PreFireHoldAnim="pre_fire_idle"
    bHasReleaseLever=true
    FuzeLength=4.000000
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.000000
    LeverReleaseRadius=200.000000
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    FireModeClass(0)=class'DH_Weapons.DH_M1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GrenadeTossFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.400000
    CurrentRating=0.400000
    DisplayFOV=70.000000
    PickupClass=class'DH_Weapons.DH_M1GrenadePickup'
    PlayerViewOffset=(X=15.000000,Y=15.000000)
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_M1GrenadeAttachment'
    ItemName="Mk II Grenade"
    Mesh=SkeletalMesh'DH_M1Grenade_1st.M1_Grenade'
}
