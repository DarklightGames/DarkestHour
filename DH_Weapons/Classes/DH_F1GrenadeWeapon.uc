//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_F1nade_1st.ukx

defaultproperties
{
    PreFireHoldAnim="pre_fire_idle"
    bHasReleaseLever=True
    FuzeLength=4.000000
    LeverReleaseSound=Sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.000000
    LeverReleaseRadius=200.000000
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    FireModeClass(0)=Class'DH_Weapons.DH_F1GrenadeFire'
    FireModeClass(1)=Class'DH_Weapons.DH_F1GrenadeTossFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.400000
    CurrentRating=0.400000
    DisplayFOV=70.000000
    PickupClass=Class'DH_Weapons.DH_F1GrenadePickup'
    PlayerViewOffset=(X=5.000000,Y=5.000000)
    BobDamping=1.600000
    AttachmentClass=Class'DH_Weapons.DH_F1GrenadeAttachment'
    ItemName="F1 Grenade"
    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.f1grenade_s'
    bUseHighDetailOverlayIndex=True
    HighDetailOverlayIndex=2
}
