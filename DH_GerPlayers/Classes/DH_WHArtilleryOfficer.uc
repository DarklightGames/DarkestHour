//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WHArtilleryOfficer extends DHGETankCrewmanRoles;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerie Offizier"
    Article="a "
    PluralName="Artillery Officers"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanArtilleryHeerPawn')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetOne'
}
