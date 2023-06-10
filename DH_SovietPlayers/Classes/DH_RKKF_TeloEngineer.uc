//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKF_TeloEngineer extends DHSOVEngineerRoles; //wears helmet and no naval cap, so doesnt need to be separated on fleets for an appropriate cap

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietMarinePaddedPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
	//SVT was more commonly used by marines than by regular army, so marine engineer gets SVT instead of m38
}
