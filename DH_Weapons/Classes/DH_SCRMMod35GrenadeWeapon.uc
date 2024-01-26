//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SCRMMod35GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="SCRM Mod.35 Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_SCRMMod35GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_SCRMMod35GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_SCRMMod35GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_SCRMMod35GrenadePickup'
    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    //Mesh=SkeletalMesh'DH_SCRMMod35_anm.SCRMMod35_1st'
    DisplayFOV=80.0
    GroupOffset=0
    bHasReleaseLever=true
}
