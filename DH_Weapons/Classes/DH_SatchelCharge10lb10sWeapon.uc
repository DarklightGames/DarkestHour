//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

defaultproperties
{
    ItemName="10lb Satchel Charge"
    Mesh=mesh'Common_Satchel_1st.Sachel_Charge'
    DrawScale=1.0
    DisplayFOV=70
    BobDamping=1.6
    PlayerViewOffset=(X=10,Y=5,Z=0)
    bCanThrow=false //cannot be dropped
    FuzeLength=15.0 //was 10    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    FireModeClass(1)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    FuzeLength=10.0
    bCanRestDeploy=false
    bHasReleaseLever=false
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim=Draw
    PutDownAnim=Put_Away
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out
    PreFireHoldAnim=Weapon_Down
    AIRating=+0.4
    CurrentRating=0.4
    bSniping=false // So bots will use this weapon to take long range shots
    SelectForce="SwitchToAssaultRifle"
    InventoryGroup=6
}
