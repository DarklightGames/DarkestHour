//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_VSGunner_Winter extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB_Winter',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Volkssturm_sleeve'
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'ROInventory.ROGermanHat'
	
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ZB30Weapon') // TO DO: wz28
    PrimaryWeapons(1)=(Item=none)
    PrimaryWeapons(2)=(Item=none)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon') // TO DO: some other weird sidearms?
    SecondaryWeapons(1)=(Item=none)
    SecondaryWeapons(2)=(Item=none)

    HandType=Hand_Gloved
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    BareHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    CustomHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    
    bCanBeSquadLeader=false
}
