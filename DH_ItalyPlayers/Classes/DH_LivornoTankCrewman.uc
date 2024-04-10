//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

// TODO: remove this class, there is no such thing as a Livorno tank crewman
// because the Livorno is an infantry division. Figure out what we want to do
// for different Italian tank units.

class DH_LivornoTankCrewman extends DHITATankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_ItalyPlayers.DH_ItalianTankCrewmanPawn',Weight=1.0)
}
