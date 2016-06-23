//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MP41Weapon extends DH_MP40Weapon;

defaultproperties
{
     MaxNumPrimaryMags=8
     InitialNumPrimaryMags=8
     FreeAimRotationSpeed=7.500000
     FireModeClass(0)=Class'DH_Weapons.DH_MP41Fire'
     FireModeClass(1)=Class'DH_Weapons.DH_MP41MeleeFire'
     PickupClass=Class'DH_Weapons.DH_MP41Pickup'
     AttachmentClass=Class'DH_Weapons.DH_MP41Attachment'
     ItemName="MP41 SMG"
     Mesh=SkeletalMesh'Axis_Mp40_1st.mp41_Mesh'
     HighDetailOverlay=Shader'Weapons1st_tex.SMG.MP41_S'
}
