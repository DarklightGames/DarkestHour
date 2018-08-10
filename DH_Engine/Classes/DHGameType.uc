//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGameType extends Info
    abstract;

var localized string    GameTypeName;
var bool                bUseInfiniteReinforcements;             // Whether this gamemode uses infinite reinforcements
var bool                bUseReinforcementWarning;               // Whether this gamemode gives out reinforcement warnings
var bool                bRoundEndsAtZeroReinf;                  // Whether the round ends as soon as a team hits 0 reinforcements
var bool                bTimeCanChangeAtZeroReinf;              // Whether this gamemode can change round time once a team reaches 0 reinforcments (other rules apply)
var bool                bSquadSpecialRolesOnly;                 // Whether this gamemode restricts roles to squad members and leaders
var bool                bKeepSpawningWithoutReinf;              // Whether this gamemode alls spawning once out of reinforcements
var bool                bHasTemporarySpawnVehicles;             // Whether this gamemode treats all vehicles as temporary spawn vehicles after their spawn
var bool                bMunitionsDrainOverTime;                // Whether this gamemode should drain munitions over time

var int                 OutOfReinfLimitForTimeChange;           // Threshold for the bTimeCanChangeAtZeroReinf, the team with reinforcements remaining must have <= this amount
var int                 OutOfReinfRoundTime;                    // The round time to set when a team runs out of reinforcements, if bTimeCanChangeAtZeroReinf

defaultproperties
{
    GameTypeName="Unknown Game Type"
}
