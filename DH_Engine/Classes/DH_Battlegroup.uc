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
    var() class<DHSquadIcon>           SquadTypeIcon;                    // The icon to use for this squad
    // var() int                          SquadLimit;                   // How many of this squad type there can be
    var() int                          SquadSize;                   // How many of this squad type there can be
    var() SquadRole            Role1Leader;             // The Roles allowed within this class
    var() SquadRole            Role2Asl;                // The Roles allowed within this class
    var() array <SquadRole>    Role3Privates;            // The Roles allowed within this class
};

var() ETeam                    NationTeam;                      // The nation this battlegroup is for
var() SquadSelection           Squads[8];
var() SquadRole                HQRole1SL;                     // The role for unassigned players
var() SquadRole                HQRole2ASL;                     // The role for unassigned players
var() array<SquadRole>         HQRolesPrivates;                     // The role for unassigned players
var() array<SquadRole>         UnAssignedSquadRoles;                     // The role for unassigned players

const SQUAD_INDEX_HQ	= 8;
const SQUAD_INDEX_UNASSIGNED = 9;


//=============================================================================
// replication
//=============================================================================

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		NationTeam, Squads;
}


simulated function class<DHSquadType> GetSquadType(int SquadIndex)
{
    if (IsSquadIndexOk(SquadIndex) && Squads[SquadIndex].SquadType != none)
    {
        return Squads[SquadIndex].SquadType;
    }

    if (SquadIndex == SQUAD_INDEX_HQ)
    {
        return class'DHSquadTypeHeadquarters';
    }

    if (IsSquadUnassigned(SquadIndex))
    {
        return class'DHSquadTypeUnassigned';
    }
    return class'DHSquadTypeGeneric';
}

simulated function bool IsSquadUnassigned(int SquadIndex)
{
    return SquadIndex < 0 || SquadIndex == SQUAD_INDEX_UNASSIGNED;
}

simulated function Material GetSquadTypeIcon(int SquadIndex)
{
    if (IsSquadIndexOk(SquadIndex) && Squads[SquadIndex].SquadTypeIcon != none)
    {
        return Squads[SquadIndex].SquadTypeIcon.default.Icon;
    }
    return Material'DH_InterfaceArt2_tex.Icons.squad';
}

simulated function string GetSquadTypeHint(int SquadIndex)
{
    if (IsSquadIndexOk(SquadIndex))
    {
        return Squads[SquadIndex].SquadTypeHint;
    }
    return "";
}

//TODO: Fix this function
simulated function class<DHRoleInfo> GetRole(int SquadIndex, int RoleIndex)
{
    // local int i;
    switch (RoleIndex)
    {
        case 0:
            return Squads[SquadIndex].Role1Leader.Role;
        case 1:
            return Squads[SquadIndex].Role2Asl.Role;
        default:
        if (IsSquadIndexOk(SquadIndex))
        {
            return Squads[SquadIndex].Role3Privates[0].Role;
        }
        return UnAssignedSquadRoles[0].Role;
    }
}

//TODO: Make this work if we want it
// simulated function array<DHRoleInfo> GetRoles(int squadIndex)
// {
//     local int i;
//     local SquadSelection SquadSel;
//     local array<DHRoleInfo> Roles;

//     if (!IsSquadIndexOk(SquadIndex))
//     {
//         if (SquadIndex  == SQUAD_INDEX_HQ)
//         {
//             Roles.Length = HQRole1SL.Limit + HQRole2ASL.Limit + HQRolesPrivates.Length;
//             if (Roles.Length < 2)
//             {
//                 return Roles;
//             }
            
//             Roles(0) = HQRole1SL.Role;
//             Roles(1) = HQRole2ASL.Role;

//             for (i = 2; i < HQRolesPrivates.Length; i++)
//             {
//                 Roles(i) = HQRolesPrivates[i - 2].Role;
//             }
//             return Roles;
//         }
//         else if (IsSquadUnassigned(SquadIndex))
//         {
//             Roles.Length = UnAssignedSquadRoles.Length;
//             for (i = 0; i < UnAssignedSquadRoles.Length; i++)
//             {
//                 Roles(i) = UnAssignedSquadRoles[i].Role;
//             }
//             return Roles;
//         }
//     }

//     SquadSel = Squads[SquadIndex];
    
//     Roles.Length = GetSquadSize(SquadIndex);
//     Roles(0) = SquadSel.Role1Leader.Role;
//     Roles(1) = SquadSel.Role2Asl.Role;

//     for (i = 2; i < roles.Length; i++)
//     {
//         Roles(i) = SquadSel.Role3Privates[i - 2].Role;
        
//     }
//     return Roles;
// }

simulated function int GetRoleLimit(DHRoleInfo RI, int SquadIndex)
{
    local SquadSelection SquadSel;

    if (SquadIndex == SQUAD_INDEX_HQ)
    {
        return GetLimitForRole(RI, HQRolesPrivates);
    }
    else if (IsSquadUnassigned(SquadIndex))
    {
        return GetLimitForRole(RI, UnAssignedSquadRoles);
    }
    else if (!IsSquadIndexOk(SquadIndex))
    {
        Log("GetRoleLimit !IsSquadIndexOk: " @ SquadIndex @ " " @ RI.Class);

        return -1;
    }

    SquadSel = Squads[SquadIndex];

    switch (RI.Class)
    {
        case SquadSel.Role1Leader.Role:
            return SquadSel.Role1Leader.Limit;
        case SquadSel.Role2Asl.Role:
            return SquadSel.Role2Asl.Limit;
        default:
            return GetLimitForRole(RI, SquadSel.Role3Privates);
    }
}

simulated function bool IsSquadIndexOk(int SquadIndex)
{
    return SquadIndex >= 0 && SquadIndex < SQUAD_INDEX_HQ;
}

simulated function string GetDefaultSquadName(int SquadIndex)
{
    if (IsSquadIndexOk(SquadIndex))
    {
        return Squads[SquadIndex].Name;
    }

    if (SquadIndex == SQUAD_INDEX_HQ)
    {
        return "Headquarters";
    }

    if (IsSquadUnassigned(SquadIndex))
    {
        return "Unassigned";
    }

    return "Squad";
}

simulated function int GetSquadSize(int SquadIndex)
{   
    if (IsSquadIndexOk(SquadIndex) && Squads[SquadIndex].SquadSize > 0)
    {
        return Squads[SquadIndex].SquadSize;
    }

    if (SquadIndex == SQUAD_INDEX_HQ)
    {
        return GetHQSquadSize();
    }

    if (IsSquadUnassigned(SquadIndex))
    {
        return 8;
    }

    return 8;
}

private simulated function int GetHQSquadSize()
{
    local int Size;
    
    Size += HQRole1SL.Limit;
    Size += HQRole2ASL.Limit;

    return Size + HQRolesPrivates.Length;
}

simulated function int GetERoleEnabledResult(DHRoleInfo RI, DHPlayer DHP, int SquadIndex)
{
    local SquadSelection SquadSel;

    if (IsSquadIndexOk(SquadIndex))
    {
        SquadSel = Squads[SquadIndex];
    }
    else if (SquadIndex == SQUAD_INDEX_HQ)
    {
        return GetERoleEnabledResultForHQ(RI, DHP);
    }
    else if (IsSquadUnassigned(SquadIndex))
    {
        return GetERoleEnabledResultForRole(RI, UnAssignedSquadRoles);
    }
    else
    {
        return 7;
    }

    if (RI.Class == SquadSel.Role1Leader.Role)
    {
        if (DHP != none && DHP.IsSL())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 4;
        }
    }
    else if (RI.Class == SquadSel.Role2Asl.Role)
    {
        if (DHP != none && DHP.IsAsl())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 5;
        }
    }
    else if (GetERoleEnabledResultForRole(RI, SquadSel.Role3Privates) == 1)
    {
        if (DHP == none || !DHP.IsSLorASL())
        {
            return 1;
        }
        else
        {
            return 6;//RER_NonSquadLeaderOnly;
        }
    }

    return 7;
}

private simulated function int GetERoleEnabledResultForHQ(DHRoleInfo RI, DHPlayer DHP)
{
    if (RI.Class == HQRole1SL.Role)
    {
        if (DHP != none && DHP.IsSL())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 4;
        }
    }
    else if (RI.Class == HQRole2ASL.Role)
    {
        if (DHP != none && DHP.IsAsl())
        {
            return 1;//RER_Enabled;
        }
        else
        {
            return 5;
        }
    }
    else if (GetERoleEnabledResultForRole(RI, HQRolesPrivates) == 1)
    {
        if (DHP == none || !DHP.IsSLorASL())
        {
            return 1;
        }
        else
        {
            return 6;//RER_NonSquadLeaderOnly;
        }
    }
    return 7;
}


private simulated function int GetERoleEnabledResultForRole(DHRoleInfo RI, array<SquadRole> roles)
{
    local int i;

    for (i = 0; i < roles.Length; i++)
    {
        if (RI.Class == roles[i].Role)
        {
            return 1;//RER_Enabled;
        }
    }
    return -1;
}

private simulated function int GetLimitForRole(DHRoleInfo RI, array<SquadRole> roles)
{
    local int i;

    for (i = 0; i < roles.Length; i++)
    {
        if (RI.Class == roles[i].Role)
        {
            return roles[i].Limit;
        }
    }
    return -1;
}

defaultproperties
{
    bStatic=true
    Texture=Texture'DHEngine_Tex.LevelInfo'
}
