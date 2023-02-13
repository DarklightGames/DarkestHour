//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CSAZ_TunicSniper extends DHCSSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_CSAZTunicGPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_CSAZTunicGBritpackPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_CSAZTunicGSidorPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_CSAZSidecap'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
}
