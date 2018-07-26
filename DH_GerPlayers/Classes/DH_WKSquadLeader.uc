//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_WKSquadLeader extends DHGESergeantRoles;

defaultproperties
{
    AltName="Scharführer"

    Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineCap'
    HeadgearProbabilities(0)=1.0
    HeadgearProbabilities(1)=0.0

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
}
