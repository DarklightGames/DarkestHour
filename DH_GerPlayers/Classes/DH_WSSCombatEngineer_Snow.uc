//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WSSCombatEngineer_Snow extends DHGEEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanParkaSnowSSPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetSnow'
    HandType=Hand_Gloved
}
