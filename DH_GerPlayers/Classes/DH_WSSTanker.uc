//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WSSTanker extends DHGETankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanTankCrewSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_WSSHatPanzerA'
    Headgear(1)=class'DH_GerPlayers.DH_WSSHatPanzerB'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M712Weapon')

    SecondaryWeapons(0)=(Item=none)
    SecondaryWeapons(1)=(Item=none) //pistols are removed so that he wouldnt get 2 pistols, m712 counting as one
}
