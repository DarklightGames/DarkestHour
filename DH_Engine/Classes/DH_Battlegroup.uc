//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DH_Battlegroup extends Info
	hidecategories(Object,Movement,Collision,Lighting,LightColor,Karma,Force,Events,Display,Advanced,Sound)
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
    var() string                       SquadTypeHint;
    var() class<DHSquadType>           SquadType;               // The Squad type class to use.
    var() int                          SquadLimit;                   // How many of this squad type there can be
    var() int                          SquadSize;                   // How many of this squad type there can be
    var() SquadRole            Role1Leader;             // The Roles allowed within this class
    var() SquadRole            Role2Asl;                // The Roles allowed within this class
    var() SquadRole            Role3;                   // The Roles allowed within this class
    var() SquadRole            Role4;                   // The Roles allowed within this class
    var() SquadRole            Role5;                   // The Roles allowed within this class
    var() SquadRole            Role6;                   // The Roles allowed within this class
};

var() string                   Name;
var() ETeam                    NationTeam;                      // The nation this battlegroup is for
var() array<SquadSelection>    Squads;
var() class<DHRoleInfo>        NoSquadRole;


// simulated function array<DHRoleInfo> GetRoles(int squadIndex)
// {
//     local SquadSelection SquadSel;
//     local DHRoleInfo Roles[6];
//     local int RoleSize;
//     SquadSel = Squads[SquadIndex];

    
//     Roles(0) = SquadSel.Role1Leader.Role;
//     Roles(1) = SquadSel.Role2Asl.Role;
//     Roles(2) = SquadSel.Role3.Role;
//     Roles(3) = SquadSel.Role4.Role;
//     Roles(4) = SquadSel.Role5.Role;
//     Roles(5) = SquadSel.Role6.Role;

//     return Roles;
// } 

//=============================================================================
// replication
//=============================================================================

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		Name, NationTeam, Squads;
}

simulated function class<DHSquadType> GetSquadType(int SquadIndex)
{
    return Squads[SquadIndex].SquadType;
}

simulated function class<DHRoleInfo> GetRole(int SquadIndex, int RoleIndex)
{
    switch (RoleIndex)
    {
        case 0:
            return Squads[SquadIndex].Role1Leader.Role;
        case 1:
            return Squads[SquadIndex].Role2Asl.Role;
        case 2:
            return Squads[SquadIndex].Role3.Role;
        case 3:
            return Squads[SquadIndex].Role4.Role;
        case 4:
            return Squads[SquadIndex].Role5.Role;
        case 5:
            return Squads[SquadIndex].Role6.Role;
        default:
            return none;
    }
}

simulated function int GetRoleLimit(DHRoleInfo RI, int SquadIndex)
{
    local SquadSelection SquadSel;

    SquadSel = Squads[SquadIndex];

    switch (RI.Class)
    {
        case SquadSel.Role1Leader.Role:
            return SquadSel.Role1Leader.Limit;
        case SquadSel.Role2Asl.Role:
            return SquadSel.Role2Asl.Limit;
        case SquadSel.Role3.Role:
            return SquadSel.Role3.Limit;
        case SquadSel.Role4.Role:
            return SquadSel.Role4.Limit;
        case SquadSel.Role5.Role:
            return SquadSel.Role5.Limit;
        case SquadSel.Role6.Role:
            return SquadSel.Role6.Limit;
        default:
            return 255;
    }
}

simulated function string GetDefaultSquadName(int SquadIndex)
{
    return Squads[SquadIndex].Name;
}

simulated function string GetSquadTypeHint(int SquadIndex)
{
    return Squads[SquadIndex].SquadTypeHint;
}

simulated function int GetSquadSize(int SquadIndex)
{   
    if (Squads[SquadIndex].SquadSize > 0)
    {
        return Squads[SquadIndex].SquadSize;
    }
    return 8;
}

// The squads that can be selected for this battlegroup 
simulated function int GetERoleEnabledResult(DHRoleInfo RI, DHPlayer DHP, int SquadIndex)
{
    local SquadSelection SquadSel;

    if (SquadIndex <= 0 || SquadIndex >= Squads.Length)
    {
        if (RI.Class == NoSquadRole)
        {
            return 1;//RER_Enabled;
        }
        return 7;
    }

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
            return 5;
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
            return 6;//RER_NonSquadLeaderOnly;
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
    bStatic=true
    Texture=Texture'DHEngine_Tex.LevelInfo'
    // Squads(0)=(Name="Rifle Squad",SquadType=class'DHSquadTypeInfantry',Limit=4,Role1Leader=class'DHAlliedSergeantRoles',Role2Asl=class'DHAlliedSergeantRoles',Role3=class'DHAlliedSergeantRoles')
}
