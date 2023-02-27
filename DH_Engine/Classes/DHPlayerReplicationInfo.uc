//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlayerReplicationInfo extends ROPlayerReplicationInfo;

// Patron status
enum EPatronTier
{
    PATRON_None,
    PATRON_Lead,
    PATRON_Bronze,
    PATRON_Silver,
    PATRON_Gold
};

enum ERoleSelector
{
    ERS_ALL,
    ERS_SL,
    ERS_ASL,
    ERS_SL_OR_ASL,
    ERS_ARTILLERY_OPERATOR,
    ERS_ARTILLERY_SPOTTER,
    ERS_RADIOMAN,
    ERS_ADMIN,
    ERS_PATRON
};

var     EPatronTier             PatronTier;
var     bool                    bIsDeveloper;

var     float                   NameDrawStartTime;
var     float                   LastNameDrawTime;
var     int                     DHKills;

// Squad
var     int                     SquadIndex;
var     int                     SquadMemberIndex;
var     bool                    bIsSquadAssistant;

// Scoring
var     int                     TotalScore;
var     int                     CategoryScores[2];

var     localized string        SquadLeaderAbbreviation;
var     localized string        AssistantAbbreviation;

var     int                     CountryIndex;
var     int                     PlayerIQ;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        SquadIndex, SquadMemberIndex, PatronTier, bIsDeveloper, DHKills, bIsSquadAssistant,
        TotalScore, CategoryScores, CountryIndex, PlayerIQ;
}

simulated function string GetNamePrefix()
{
    if (IsSquadLeader())
    {
        return default.SquadLeaderAbbreviation;
    }
    else if (bIsSquadAssistant)
    {
        return default.AssistantAbbreviation;
    }
    else if (IsInSquad())
    {
        return string(SquadMemberIndex + 1);
    }

    return "";
}

simulated function bool IsLoggedInAsAdmin()
{
    return bAdmin || bSilentAdmin || Level.NetMode == NM_Standalone;
}

simulated function bool IsSquadLeader()
{
    return IsInSquad() && SquadMemberIndex == 0;
}

// TODO: GET RID OF THIS!
simulated function bool IsSL()
{
    return IsSquadLeader();
}

simulated function bool IsAssistantLeader()
{
    return IsInSquad() && bIsSquadAssistant;
}

simulated function bool IsASL()
{
    return IsAssistantLeader();
}

simulated function bool IsSLorASL()
{
    return IsSL() || IsASL();
}

simulated function bool IsInSquad()
{
    return Team != none && (Team.TeamIndex == AXIS_TEAM_INDEX || Team.TeamIndex == ALLIES_TEAM_INDEX) && SquadIndex != -1;
}

simulated function bool HasSquadMembers(int MinCount)
{
    local DHPlayer PC;
    local DHSquadReplicationInfo SRI;

    if (!IsInSquad())
    {
        return false;
    }

    PC = DHPlayer(Owner);

    if (PC != none)
    {
        SRI = PC.SquadReplicationInfo;
    }

    return SRI != none &&
           Team != none &&
           SRI.GetMemberCount(Team.TeamIndex, SquadIndex) >= MinCount;
}

simulated function bool IsPatron()
{
    return PatronTier != PATRON_None;
}

simulated function bool IsRadioman()
{
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    return PC != none && PC.IsRadioman();
}

simulated function bool IsArtilleryOperator()
{
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    return PC != none && PC.IsArtilleryOperator();
}

simulated function bool IsArtillerySpotter()
{
    local DHPlayer PC;

    PC = DHPlayer(Owner);

    return PC != none && PC.IsArtillerySpotter();
}

simulated function bool IsAdmin()
{
    return self.bAdmin || self.bSilentAdmin
      || (self.Level != none && self.Level.NetMode == NM_Standalone);
}

// Will return true if passed two players that are in the same squad.
simulated static function bool IsInSameSquad(DHPlayerReplicationInfo A, DHPlayerReplicationInfo B)
{
    return A != none && A.Team != none && B != none && B.Team != none &&
          (A.Team.TeamIndex == AXIS_TEAM_INDEX || A.Team.TeamIndex == ALLIES_TEAM_INDEX) &&
           A.Team.TeamIndex == B.Team.TeamIndex &&
           A.SquadIndex >= 0 && A.SquadIndex == B.SquadIndex;
}

// New helper function to check whether a player can be tank crew
simulated static function bool IsPlayerTankCrew(Pawn P)
{
    return P != none && ROPlayerReplicationInfo(P.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew;
}

simulated static function bool IsPlayerLicensedToDrive(DHPlayer C)
{
    return C != none && DHPlayerReplicationInfo(C.PlayerReplicationInfo) != none && DHPlayerReplicationInfo(C.PlayerReplicationInfo).IsSLorASL();
}

// Modified to fix bug where the last line was being drawn at top of screen, instead of in vertical sequence, so overwriting info in the 1st screen line
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    if (Team != none)
    {
        Canvas.DrawText("     PlayerName" @ PlayerName @ "Team" @ Team.GetHumanReadableName() $ "(" $ Team.TeamIndex $ ") has flag" @ HasFlag);
    }
    else
    {
        Canvas.DrawText("     PlayerName" @ PlayerName @ "NO Team");
    }

    if (!bBot)
    {
        YPos += YL;
        Canvas.SetPos(4.0, YPos); // bug was here, as it was setting Y draw position to YL not YPos
        Canvas.DrawText("     bIsSpec:" $ bIsSpectator @ "OnlySpec:" $ bOnlySpectator @ "Waiting:" $ bWaitingPlayer @ "Ready:" $ bReadyToPlay @ "OutOfLives:" $ bOutOfLives);
    }
}

simulated function bool CheckRole(ERoleSelector RoleSelector)
{
    switch (RoleSelector)
    {
        case ERS_ALL:
            return true;
        case ERS_SL:
            return IsSL();
        case ERS_ASL:
            return IsASL();
        case ERS_ARTILLERY_SPOTTER:
            return IsArtillerySpotter();
        case ERS_ARTILLERY_OPERATOR:
            return IsArtilleryOperator();
        case ERS_RADIOMAN:
            return IsRadioman();
        case ERS_ADMIN:
            return IsAdmin();
        case ERS_PATRON:
            return IsPatron();
        default:
            return false;
    }

    return false;
}

simulated function bool CanAccessCommandChannel()
{
    return IsAssistantLeader() ||
           (IsSquadLeader() && HasSquadMembers(2));
}

// Functions emptied out as RO/DH doesn't use a LocalStatsScreen actor, so all of this is just recording pointless information throughout each round
function AddWeaponKill(class<DamageType> D);
function AddVehicleKill(class<VehicleDamageType> D);
function AddWeaponDeath(class<DamageType> D);
function AddWeaponDeathHolding(class<Weapon> W);
function AddVehicleDeath(class<DamageType> D);
function AddVehicleDeathDriving(class<Vehicle> V);
simulated function UpdateWeaponStats(TeamPlayerReplicationInfo PRI, class<Weapon> W, int NewKills, int NewDeaths, int NewDeathsHolding);
simulated function UpdateVehicleStats(TeamPlayerReplicationInfo PRI, class<Vehicle> V, int NewKills, int NewDeaths, int NewDeathsDriving);

defaultproperties
{
    SquadIndex=-1
    SquadMemberIndex=-1
    SquadLeaderAbbreviation="SL"
    AssistantAbbreviation="A"
    CountryIndex=-1
}
