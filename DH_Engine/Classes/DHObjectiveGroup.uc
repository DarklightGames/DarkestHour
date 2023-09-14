//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObjectiveGroup extends Info
    placeable;

var() float OwnedAttritionRate[2];
var   int   GroupIndex;

var private array<DHObjective> Objectives;

simulated function PostBeginPlay()
{
    local DarkestHourGame DHG;

    if (Role == ROLE_Authority)
    {
        DHG = DarkestHourGame(Level.Game);

        if (DHG != none)
        {
            DHG.ObjectiveGroups[DHG.ObjectiveGroups.Length] = self;
        }
    }
}

function bool IsValid()
{
    return Objectives.Length > 0;
}

function AddObjective(DHObjective Obj)
{
    if (Obj == none)
    {
        Warn("Failed to add objective");
        return;
    }

    Objectives[Objectives.Length] = Obj;
}

function bool IsOwnedByTeam(byte TeamIndex)
{
    local int i;

    for (i = 0; i < Objectives.Length; ++i)
    {
        if (Objectives[i] != none && !Objectives[i].IsOwnedByTeam(TeamIndex))
        {
            return false;
        }
    }

    return true;
}

function byte GetOwnerTeamIndex()
{
    local int i;
    local DHObjective TempObj;

    for (i = 0; i < Objectives.Length; ++i)
    {
        if (Objectives[i] == none)
        {
            Warn("Fatal error: Missing objective.");
            continue;
        }

        if (TempObj == none)
        {
            TempObj = Objectives[i];
        }
        else if (TempObj.ObjState != Objectives[i].ObjState)
        {
            return 255;
        }
    }

    if (TempObj != none)
    {
        return TempObj.GetTeamIndex();
    }
    else
    {
        return 255;
    }
}

function float GetOwnedAttritionRate(byte OwnerTeamIndex)
{
    if (OwnerTeamIndex >= 0 && OwnerTeamIndex < arraycount(OwnedAttritionRate))
    {
        return OwnedAttritionRate[OwnerTeamIndex];
    }
}

defaultproperties
{
    Texture=Texture'DHEngine_Tex.ObjectiveGroup'
    GroupIndex=-1
}
