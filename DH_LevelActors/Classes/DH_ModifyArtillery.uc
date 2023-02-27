//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// This actor allows level designers to enable/disable artillery on certain
// events.
//
// TODO: Broadcast announcement messages when artillery changes it's status.

class DH_ModifyArtillery extends DH_ModifyActors;

struct SArtilleryStatusModifier
{
    var() int              ArtilleryTypeIndex; // in DH_Levelnfo.ArtilleryTypes
    var() StatusModifyType HowToModify;
};

var() array<SArtilleryStatusModifier> ArtilleryStatusModifiers;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (ArtilleryStatusModifiers.Length <= 0)
    {
        Warn("No actions are specified. Self-destructing!");
        Destroy();
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local DarkestHourGame DHG;
    local DHGameReplicationInfo GRI;
    local int i, TypeIndex;

    DHG = DarkestHourGame(Level.Game);

    if (DHG != none)
    {
        GRI = DHG.GRI;
    }

    if (GRI == none || DHG.DHLevelInfo == none)
    {
        Warn("Fatal error!");
        return;
    }

    for (i = 0; i < ArtilleryStatusModifiers.Length; ++i)
    {
        TypeIndex = ArtilleryStatusModifiers[i].ArtilleryTypeIndex;

        if (TypeIndex < 0 ||
            TypeIndex >= arraycount(GRI.ArtilleryTypeInfos) ||
            TypeIndex >= DHG.DHLevelInfo.ArtilleryTypes.Length)
        {
            Warn("Failed action [" $ i $ "]: ArtilleryTypeIndex is invalid.");
            continue;
        }

        switch (ArtilleryStatusModifiers[i].HowToModify)
        {
            case SMT_Activate:
                GRI.ArtilleryTypeInfos[TypeIndex].bIsAvailable = true;
                break;

            case SMT_Deactivate:
                GRI.ArtilleryTypeInfos[TypeIndex].bIsAvailable = false;
                break;

            case SMT_Toggle:
                GRI.ArtilleryTypeInfos[TypeIndex].bIsAvailable = !GRI.ArtilleryTypeInfos[TypeIndex].bIsAvailable;
                break;
        }
    }
}

defaultproperties
{
    Texture=Texture'Engine.S_Trigger'
}
