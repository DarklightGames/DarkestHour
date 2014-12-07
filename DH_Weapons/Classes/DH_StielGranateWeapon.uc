//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StielGranateWeapon extends DH_GrenadeWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Granate_1st.ukx

defaultproperties
{
    PreFireHoldAnim="pre_fire_idle"
    FuzeLength=5.000000
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    FireModeClass(0)=class'DH_Weapons.DH_StielGranateFire'
    FireModeClass(1)=class'DH_Weapons.DH_StielGranateTossFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.400000
    CurrentRating=0.400000
    DisplayFOV=70.000000
    PickupClass=class'DH_Weapons.DH_StielGranatePickup'
    PlayerViewOffset=(X=5.000000,Y=5.000000)
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_StielGranateAttachment'
    ItemName="Stielhandgranate 39/43"
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Grenades.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
