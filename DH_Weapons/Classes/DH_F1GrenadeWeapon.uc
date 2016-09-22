//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadeWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_F1nade_1st.ukx

defaultproperties
{
    PreFireHoldAnim="pre_fire_idle"
    bHasReleaseLever=true
    FuzeLength=4.0
    LeverReleaseSound=sound'Inf_Weapons_Foley.F1.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    FireModeClass(0)=class'DH_Weapons.DH_F1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_F1GrenadeTossFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    PickupClass=class'DH_Weapons.DH_F1GrenadePickup'
    PlayerViewOffset=(X=5.0,Y=5.0)
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_F1GrenadeAttachment'
    ItemName="F1 Grenade"
    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.f1grenade_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    InventoryGroup=2
}

