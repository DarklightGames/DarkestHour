//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckWeapon extends DH_RocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Panzerschreck_1st.ukx

defaultproperties
{
    Ranges(1)=350
    Ranges(2)=675
    FireModeClass(0)=class'DH_ATWeapons.DH_PanzerschreckFire'
    FireModeClass(1)=class'DH_ATWeapons.DH_PanzerschreckMeleeFire'
    PickupClass=class'DH_ATWeapons.DH_PanzerschreckPickup'
    AttachmentClass=class'DH_ATWeapons.DH_PanzerschreckAttachment'
    ItemName="Panzerschreck"
    Mesh=SkeletalMesh'DH_Panzerschreck_1st.Panzerschreck'
    FillAmmoMagCount=1
    WarningMessageClass=class'DH_ATWeapons.DH_PanzerschreckWarningMsg'
}
