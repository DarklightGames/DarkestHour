//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZ_BritcoatAntiTank_Winter extends DHCSAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_CSAZbritcoatPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_CSAZbritcoatSidorPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTommyHelmetSnow'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Coat_Sleeves'
    //Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon') too late for Sokolovo
    GivenItems(0)="none"
    HandType=Hand_Gloved
}
