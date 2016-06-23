//=============================================================================
// RDG1GrenadeAttachment
//=============================================================================
// Russian RDG1 smoke grenade Weapon attachment
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2006 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_RPG43GrenadeAttachment extends DH_StielGranateAttachment;

#exec OBJ LOAD File=DO_RU_Weapons.ukx
//#exec OBJ LOAD File=DO_RU_Weapons.utx

defaultproperties
{
     WA_Idle="Idle"
     WA_Fire="Idle"
     //compile error  menuImage=texture'DH_ROFX_Tex.HUD.rpg43gui'
     MenuDescription="RPG-43 ||HEAT based Soviet hand grenade. ||Explodes on sudden impact and has a penetration of around 75 mm of armor."
     //compile error  mesh=SkeletalMesh'DO_RU_Weapons.RPG_43_3rd'
}
