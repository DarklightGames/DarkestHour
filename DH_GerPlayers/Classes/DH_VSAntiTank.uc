//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_VSAntiTank extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawn')
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves' // similar color; to do (?) - make distinct texture
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetOne'
		
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_VK98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
	
    GivenItems(0)="DH_Weapons.DH_PanzerfaustWeapon"
    GivenItems(1)="none"
}
