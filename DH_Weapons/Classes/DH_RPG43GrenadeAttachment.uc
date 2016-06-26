//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadeAttachment extends DH_StielGranateAttachment;

#exec OBJ LOAD File=DO_RU_Weapons.ukx

defaultproperties
{
     WA_Idle="Idle"
     WA_Fire="Idle"
     //compile error  menuImage=texture'DH_ROFX_Tex.HUD.rpg43gui'
     //compile error  mesh=SkeletalMesh'DO_RU_Weapons.RPG_43_3rd'
}
