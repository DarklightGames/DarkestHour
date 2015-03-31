//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BazookaWeapon extends DH_RocketWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Bazooka_1st.ukx

defaultproperties
{
    Ranges(0)=15
    Ranges(1)=850
    Ranges(2)=2450
    FireModeClass(0)=class'DH_ATWeapons.DH_BazookaFire'
    FireModeClass(1)=class'DH_ATWeapons.DH_BazookaMeleeFire'
    PickupClass=class'DH_ATWeapons.DH_BazookaPickup'
    AttachmentClass=class'DH_ATWeapons.DH_BazookaAttachment'
    ItemName="M1A1 Bazooka"
    Mesh=SkeletalMesh'DH_Bazooka_1st.Bazooka'
    FillAmmoMagCount=1
}
