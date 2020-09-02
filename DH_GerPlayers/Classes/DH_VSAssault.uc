//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_VSAssault extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawn')
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Volkssturm_sleeve' 
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetThree'

	
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch') //to be replaced with mp3008
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
}
