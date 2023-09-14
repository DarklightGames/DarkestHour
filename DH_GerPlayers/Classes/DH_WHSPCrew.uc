//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WHSPCrew extends DHGETankCrewmanRoles;

defaultproperties
{
    MyName="Assault Gun Crewman"
    AltName="Stugbesatzung"
    Article="a "
    PluralName="Assault Gun Crewmen"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanSPGunCrewPawn')
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'DH_GerPlayers.DH_HeerCamoCap'
}
