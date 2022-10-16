//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_WHAntiTank_SnowTwo extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanSnowGreatCoatPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSnowHeerPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.snow_sleeves'
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetSnowTwo'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetSnowThree'
    Headgear(2)=class'DH_GerPlayers.DH_HeerHelmetSnow'
    Headgear(3)=class'DH_GerPlayers.DH_HeerHelmetCover'
    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.25
    HeadgearProbabilities(2)=0.3
    HeadgearProbabilities(3)=0.05
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon_Winter"
    HandType=HAND_Gloved
}
