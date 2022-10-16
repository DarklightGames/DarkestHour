//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_StandardRadioOperatorLate extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicStrapsLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43PawnAStraps',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43GreenPawnAStraps',Weight=1.0)
    RolePawns(3)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicM43DarkPawnAStraps',Weight=1.0)

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
	Backpack(0)=(BackpackClass=class'DH_SovietPlayers.DH_SovRadioBackpack',LocationOffset=(X=-0.1))

}
