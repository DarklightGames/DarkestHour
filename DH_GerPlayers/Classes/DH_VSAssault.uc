//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_VSAssault extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanGreatCoatPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'ROInventory.ROGermanHat'


    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_VG15weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch') //to do: mp3008
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
}
