//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WSSSniper extends DHGESniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanSSPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSpringSmockSSPawn',Weight=2.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.DotGreenSleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BHPWeapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_TT33Weapon')
}
