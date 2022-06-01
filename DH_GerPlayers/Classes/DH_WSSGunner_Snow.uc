//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_WSSGunner_Snow extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanParkaSnowSSPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve' //to do
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetSnow'
    HeadgearProbabilities(0)=1.0
    
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ZB30Weapon')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_C96Weapon')
    HandType=Hand_Gloved
}
