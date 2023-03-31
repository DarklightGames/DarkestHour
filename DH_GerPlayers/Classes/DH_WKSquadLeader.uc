//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WKSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    AltName="Scharführer"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanKriegsmarinePawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineCap'
    HeadgearProbabilities(0)=1.0

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}
