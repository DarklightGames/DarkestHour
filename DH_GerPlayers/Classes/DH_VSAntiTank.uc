//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_VSAntiTank extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'ROInventory.ROGermanHat'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_VK98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')

    GivenItems(0)="DH_Weapons.DH_PanzerfaustWeapon"
    GivenItems(1)="none"
}
