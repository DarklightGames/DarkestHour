//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_StandardRiflemanEarly extends DHSOVRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicBackpackEarlyPawn',Weight=6.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicBackpackEarlyDarkPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicEarlyPawn',Weight=3.0)

    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
}
