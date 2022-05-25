//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_WSSGunner_Autumn extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanParkaSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanAutumnSmockSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'

    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ZB30Weapon')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_C96Weapon')
}
