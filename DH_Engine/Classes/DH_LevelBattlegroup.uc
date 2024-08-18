//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DH_LevelBattlegroup extends Actor
    placeable;

enum ETeam
{
    TEAM_AXIS,
    TEAM_ALLIES,
};

struct SquadSelection
{
    var() string                        Name;
    var() class<DHSquadType>            SquadType;                  // The Squad type class to use.
    var() int                           Limit;                      // How many of this squad type there can be
    var() class<DHRoleInfo>             Role1Leader;                   // The Roles allowed within this class
    var() class<DHRoleInfo>             Role2Asl;                   // The Roles allowed within this class
    var() class<DHRoleInfo>             Role3;                   // The Roles allowed within this class
    var() class<DHRoleInfo>             Role4;                   // The Roles allowed within this class
    var() class<DHRoleInfo>             Role5;                   // The Roles allowed within this class
    var() class<DHRoleInfo>             Role6;                   // The Roles allowed within this class
};

var() string                   Name;
var() ETeam                    Team;                            // The nation this battlegroup is for
var() array<SquadSelection>    Squads;                          // The squads that can be selected for this battlegroup 


// var() material              SquadIcon;        // Used to stop loading screen image from being removed on save (not otherwise used)

// simulated static function DH_LevelInfo GetInstance(LevelInfo Level)
// {
//     local DarkestHourGame G;
//     local DHPlayer PC;
//     local DH_LevelInfo LI;

//     if (Level.Role == ROLE_Authority)
//     {
//         G = DarkestHourGame(Level.Game);

//         if (G != none)
//         {
//             LI = G.DHLevelInfo;
//         }
//     }
//     else
//     {
//         PC = DHPlayer(Level.GetLocalPlayerController());

//         if (PC != none)
//         {
//             LI = PC.ClientLevelInfo;
//         }
//     }

//     if (LI == none)
//     {
//         foreach Level.AllActors(class'DH_LevelInfo', LI)
//         {
//             break;
//         }
//     }

//     return LI;
// }

defaultproperties
{
    Texture=Texture'DHEngine_Tex.LevelInfo'
    Name="101 Airborne"
    Team=TEAM_ALLIES
    Squads(0)=(Name="Rifle Squad",SquadType=class'DHSquadTypeInfantry',Limit=4,Role1Leader=class'DH_USPlayers.DH_USRiflemanSummer')
}
