//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
var bool                bOmitTimeAttritionForDefender;          // Whether the defender can take attrition over time from ElapsedTimeAttritionCurve

var bool                bAreObjectiveSpawnsEnabled;             // Whether this gamemode uses objective spawns
var bool                bAreRallyPointsEnabled;                 // Whether this gamemode should allow rally points for squads
var bool                bAreConstructionsEnabled;               // Whether this gamemode should allow constructions

var int                 ObjSpawnMinimumDepth;                   // Used in calculating the nearest objective spawn

var int                 OutOfReinfLimitForTimeChange;           // Threshold for the bTimeCanChangeAtZeroReinf, the team with reinforcements remaining must have <= this amount
var int                 OutOfReinfRoundTime;                    // The round time to set when a team runs out of reinforcements, if bTimeCanChangeAtZeroReinf

var InterpCurve         ElapsedTimeAttritionCurve;              // Curve which inputs elapsed time and outputs attrition amount
                                                                // used to setup a pseudo time limit for Advance/Attrition game modes
                                                                // this way if there are too many reinforcements, the round will end in a sane amount of time
defaultproperties
{
    GameTypeName="Unknown Game Type"

    ElapsedTimeAttritionCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=7200.0,OutVal=0.0),(InVal=10800.0,OutVal=100.0),(InVal=14400.0,OutVal=1000.0)))
}
