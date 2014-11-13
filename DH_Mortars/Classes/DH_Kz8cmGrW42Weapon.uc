//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Kz8cmGrW42Weapon extends DH_MortarWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mortars_1st.ukx

defaultproperties
{
     DeployAnimation="Deploy"
     VehicleClass=Class'DH_Mortars.DH_Kz8cmGrW42Vehicle'
     SelectAnim="Draw"
     PutDownAnim="putaway"
     Description="Kurz 8cm Granatwerfer 42"
     AttachmentClass=Class'DH_Mortars.DH_Kz8cmGrW42Attachment'
     ItemName="Kurz 8cm Granatwerfer 42"
     Mesh=SkeletalMesh'DH_Mortars_1st.Kz8cmGrW42'
}
