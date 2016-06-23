//=============================================================================
// RDG1GrenadeAttachment
//=============================================================================
// Russian RDG1 smoke grenade Weapon attachment
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2006 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_RDG1GrenadeAttachment extends DH_StielGranateAttachment;

defaultproperties
{
     WA_Idle="Idle"
	 WA_Fire="Idle"
	 menuImage=Texture'InterfaceArt_tex.Menu_weapons.RDG1'
	 MenuDescription="RDG-1: basic Russian smoke grenade. The handle allows it to be thrown a good distance."
	 Mesh=SkeletalMesh'Weapons3rd_anm.RGD1'
}
