//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHSquad extends Object
    abstract;

struct RoleLimit
{
    var int MemberCount;
    var int Limit;
};

struct Role
{
    var class<DHRoleInfo> Class;
    var array<RoleLimit> Limits;
};

struct SquadContext
{
    var DHSquadReplicationInfo SRI;
    var int TeamIndex;
    var int SquadIndex;
};

var localized string SquadName;
var array<Role> Roles;
var int SquadSize;

static function int GetRoleIndex(class<DHRoleInfo> RoleClass)
{
    local int i;

    for (i = 0; i < default.Roles.Length; ++i)
    {
        if (default.Roles[i].Class == RoleClass)
        {
            return i;
        }
    }

    return -1;
}

static function int GetRoleLimit(SquadContext Context, class<DHRoleInfo> RoleInfo)
{
    local int i, RoleIndex, MemberCount;

    RoleIndex = GetRoleIndex(RoleInfo);

    if (RoleIndex == -1)
    {
        // Role not found.
        return 0;
    }

    if (default.Roles[RoleIndex].Limits.Length == 0)
    {
        // Role has no limits.
        return -1;
    }


    MemberCount = Context.SRI.GetMemberCount(Context.TeamIndex, Context.SquadIndex);

    for (i = 0; i < default.Roles[RoleIndex].Limits.Length; ++i)
    {
        if (MemberCount >= default.Roles[RoleIndex].Limits[i].MemberCount)
        {
            return default.Roles[RoleIndex].Limits[i].Limit;
        }
    }

    return 0;
}

// The number of players allowed to join the squad.
static function int GetSquadSize()
{
    return default.SquadSize;
}

defaultproperties
{
    SquadName="Infantry Squad"
    Roles(0)=(Class=class'DH_USRifleman1st')
    Roles(1)=(Class=class'DH_USSergeant1st',Limits=((MemberCount=3,Limit=1)))
}
