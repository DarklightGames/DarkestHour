//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MP41Weapon extends DH_MP40Weapon;

defaultproperties
{
    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
    FreeAimRotationSpeed=7.5
    FireModeClass(0)=class'DH_Weapons.DH_MP41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP41MeleeFire'
    PickupClass=class'DH_Weapons.DH_MP41Pickup'
    AttachmentClass=class'DH_Weapons.DH_MP41Attachment'
    ItemName="Maschinenpistole 41"
    Mesh=SkeletalMesh'Axis_Mp40_1st.mp41_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.MP41_S'
}
