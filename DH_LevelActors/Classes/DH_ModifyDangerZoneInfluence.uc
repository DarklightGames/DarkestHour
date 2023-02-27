//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Use this to modify the danger zone influences for objectives dynamically.
//==============================================================================

class DH_ModifyDangerZoneInfluence extends DH_ModifyActors;

enum EInfluenceType
{
    IT_Base,
    IT_Axis,
    IT_Allies,
    IT_Neutral
};

struct DangerZoneInfluence
{
    var()   EInfluenceType  Type;
    var()   name            ObjectiveTag;
    var()   float           NewInfluence;
};

var()   array<DangerZoneInfluence>  DangerZoneInfluences;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int i;
    local DHObjective Objective;
    local DHGameReplicationInfo GRI;

    for (i = 0; i < DangerZoneInfluences.Length; ++i)
    {
        foreach AllActors(class'DHObjective', Objective, DangerZoneInfluences[i].ObjectiveTag)
        {
            switch (DangerZoneInfluences[i].Type)
            {
                case IT_Base:
                    Objective.BaseInfluenceModifier = DangerZoneInfluences[i].NewInfluence;
                    break;
                case IT_Axis:
                    Objective.AxisInfluenceModifier = DangerZoneInfluences[i].NewInfluence;
                    break;
                case IT_Allies:
                    Objective.AlliesInfluenceModifier = DangerZoneInfluences[i].NewInfluence;
                    break;
                case IT_Neutral:
                    Objective.NeutralInfluenceModifier = DangerZoneInfluences[i].NewInfluence;
                    break;
            }

            Objective.OnInfluenceChanged();
        }
    }

    // In standalone mode, we need to update the danger zone here.
    if (Level.NetMode == NM_Standalone)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none)
        {
            GRI.DangerZoneUpdated();
        }
    }
}
