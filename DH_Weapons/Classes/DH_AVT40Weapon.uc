//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_AVT40Weapon extends DHAutoWeapon;

simulated function ToggleFireMode()
{
    PlaySound(Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01',, 2.0);

    // Toggles the fire mode between single and auto
    if (bHasSelectFire)
    {
        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
    }
}

defaultproperties
{
    ItemName="AVT-40"
    SwayModifyFactor=0.72 // -0.08
    FireModeClass(0)=class'DH_Weapons.DH_AVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_AVT40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_AVT40Attachment'
    PickupClass=class'DH_Weapons.DH_AVT40Pickup'

    Mesh=SkeletalMesh'Allies_Svt40_1st.svt40_mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=25.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_AVT40Barrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim=null
    SelectFireIronAnim=null

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
}
