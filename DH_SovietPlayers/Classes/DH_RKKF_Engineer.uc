//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKF_Engineer extends DHSOVEngineerRoles; //wears helmet and no naval cap, so doesnt need to be separated on fleets for an appropriate cap

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietMarineBushlatNoBeltPawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.NavalSleeves2'

    PrimaryWeapons(0)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_SVT38Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
	//SVT was more commonly used by marines than by regular army, so marine engineer gets SVT instead of m38
}
