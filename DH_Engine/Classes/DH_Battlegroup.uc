//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DH_Battlegroup extends Actor
    placeable;

enum ETeam
{
    TEAM_AXIS,
    TEAM_ALLIES,
};

struct SquadRole
{
    var() int                           Limit;                   // How many of this squad type there can be
    var() class<DHRoleInfo>             Role;
};

struct SquadSelection
{
    var() string                       Name;
    var() class<DHSquadType>           SquadType;               // The Squad type class to use.
    var() int                          SquadLimit;                   // How many of this squad type there can be
    var() SquadRole            Role1Leader;             // The Roles allowed within this class
    var() SquadRole            Role2Asl;                // The Roles allowed within this class
    var() SquadRole            Role3;                   // The Roles allowed within this class
    var() SquadRole            Role4;                   // The Roles allowed within this class
    var() SquadRole            Role5;                   // The Roles allowed within this class
    var() SquadRole            Role6;                   // The Roles allowed within this class
};

var() string                   Name;
var() ETeam                    NationTeam;                      // The nation this battlegroup is for
var() array<SquadSelection>    Squads;                          // The squads that can be selected for this battlegroup 

simulated function int GetERoleEnabledResult(DHRoleInfo RI, DHPlayer DHP, int SquadIndex)
{
    local SquadSelection SquadSel;

    SquadSel = Squads[SquadIndex];

    if (RI.Class == SquadSel.Role1Leader.Role)
    {
        if (DHP.IsSL())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 4;
        }
    }

    if (RI.Class == SquadSel.Role2Asl.Role)
    {
        if (DHP.IsAsl())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 4;
        }
    }
    else if (((SquadSel.Role3.Role == RI.Class ) || 
    (SquadSel.Role4.Role == RI.Class) || 
    (SquadSel.Role5.Role == RI.Class) ||
     (SquadSel.Role6.Role == RI.Class)))
    {
        if (!DHP.IsSLorASL())
        {
            return 1;
        }
        else
        {
            return 5;//RER_NonSquadLeaderOnly;
        }
    }

    return 7;//RER_SquadTypeOnlyInfantry; //RER_SquadTypeOnlyInfantry;
}

// var() material              SquadIcon;        // Used to stop loading screen image from being removed on save (not otherwise used)

// simulated static function DH_BattleGroup GetInstance(LevelInfo Level, ETeam Team)
// {
//     local DarkestHourGame G;
//     local DHPlayer PC;
//     local DH_BattleGroup BG;

//     if (Level.Role == ROLE_Authority)
//     {
//         G = DarkestHourGame(Level.Game);

//         if (G != none)
//         {
//             if (Team == ETeam.TEAM_Axis)
//             {
//                 BG = G.DH_BattlegroupAxis;
//             }
//             else
//             {
//                 BG = G.DH_BattlegroupAllied;
//             }
//         }
//     }
//     else
//     {
//         PC = DHPlayer(Level.GetLocalPlayerController());

//         if (PC != none)
//         {
//             if (Team == ETeam.TEAM_Axis)
//             {
//                 BG = PC.ClientBattlegroupAxis;
//             }
//             else
//             {
//                 BG = PC.ClientBattlegroupAllied;
//             }
//         }
//     }

//     if (BG == none)
//     {
//         foreach Level.AllActors(class'DH_BattleGroup', BG)
//         {
//             if (BG.NationTeam == Team)
//             {
//                 break;
//             }
//         }
//     }

//     return BG;
// }

defaultproperties
{
    Texture=Texture'DHEngine_Tex.LevelInfo'
    // Squads(0)=(Name="Rifle Squad",SquadType=class'DHSquadTypeInfantry',Limit=4,Role1Leader=class'DHAlliedSergeantRoles',Role2Asl=class'DHAlliedSergeantRoles',Role3=class'DHAlliedSergeantRoles')
}
