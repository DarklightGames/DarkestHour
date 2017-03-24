//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_EnfieldNo4Weapon extends DHBoltActionWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_EnfieldNo4_1st.ukx

// Modified to add hint about weapon's two clip loading capacity
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(21, true);
    }
}

defaultproperties
{
    ItemName="Lee Enfield No.4 Rifle"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo4Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo4MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo4Attachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo4Pickup'

    Mesh=SkeletalMesh'DH_EnfieldNo4_1st.EnfieldNo4'
    Skins(3)=shader'Weapons1st_tex.Bullets.kar98k_stripper_s' // TODO: ammo & bayo specularity shaders aren't used in the anim mesh & should be added there
    Skins(4)=shader'DH_Weapon_tex.Spec_Maps.EnfieldNo4Bayo_s'
    HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.EnfieldNo4Main_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=90.0
    IronSightDisplayFOV=20.0
    ZoomOutTime=0.2
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    bTwoMagsCapacity=true

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    PutDownAnim="putaway"
    BoltIronAnim="iron_bolt"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
}
