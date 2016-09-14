//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_US_Winter_Infantry extends DH_American_Units
    abstract;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USWinterGISPawn',Weight=3.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USWinterPawn',Weight=6.0)
    RolePawns(2)=(PawnClass=class'DH_USPlayers.DH_USWinterGIPawn',Weight=2.0)
}
