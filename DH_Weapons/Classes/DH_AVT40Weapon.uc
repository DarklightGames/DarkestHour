//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_AVT40Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="AVT-40"
    SwayModifyFactor=0.72 // -0.08
    FireModeClass(0)=class'DH_Weapons.DH_AVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_AVT40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_AVT40Attachment'
    PickupClass=class'DH_Weapons.DH_AVT40Pickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt40_1st'
    Skins(2)=Texture'Weapons1st_tex.Rifles.svt40_sniper'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.svt40_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=32.0
	DisplayFOV=85.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_AVT40Barrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim=null
    SelectFireIronAnim=null
    SelectFireSound=Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01'

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
}
