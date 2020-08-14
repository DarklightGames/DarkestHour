//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

// This actor allows level designers to enable/disable artillery on certain
// events.
//
// TODO: Broadcast announcement messages when artillery changes it's status.

class DH_ModifyArtillery extends DH_ModifyActors;

enum EModifyArtilleryError
{
    ERROR_None,
    ERROR_Fatal,
    ERROR_IndexOutOfBounds
};

var() int              ArtilleryTypeIndex; // in DH_Levelnfo.ArtilleryTypes
var() StatusModifyType HowToModify;

function PostBeginPlay()
{
    local DarkestHourGame DHG;
    local EModifyArtilleryError ErrorType;

    super.PostBeginPlay();

    DHG = DarkestHourGame(Level.Game);

    if (DHG == none || DHG.GRI == none)
    {
        ErrorType = ERROR_Fatal;
    }
    else if (ArtilleryTypeIndex < 0 ||
             ArtilleryTypeIndex >= arraycount(DHG.GRI.ArtilleryTypeInfos))
    {
        ErrorType = ERROR_IndexOutOfBounds;
    }

    if (ErrorType != ERROR_None)
    {
        Warn(GetModifyArtilleryErrorString(ErrorType) @ "Self-destructing!");
        Destroy();
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local DarkestHourGame DHG;
    local EModifyArtilleryError ErrorType;

    DHG = DarkestHourGame(Level.Game);

    if (DHG == none || DHG.GRI == none)
    {
        ErrorType = ERROR_Fatal;
    }
    else if (ArtilleryTypeIndex < 0 ||
             ArtilleryTypeIndex >= arraycount(DHG.GRI.ArtilleryTypeInfos))
    {
        ErrorType = ERROR_IndexOutOfBounds;
    }

    if (ErrorType != ERROR_None)
    {
        Warn(GetModifyArtilleryErrorString(ErrorType) @ "Failed to trigger!");
        return;
    }

    switch (HowToModify)
    {
        case SMT_Activate:
            DHG.GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].bIsAvailable = true;
            break;

        case SMT_Deactivate:
            DHG.GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].bIsAvailable = false;
            break;

        case SMT_Toggle:
            DHG.GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].bIsAvailable = !DHG.GRI.ArtilleryTypeInfos[ArtilleryTypeIndex].bIsAvailable;
            break;
    }
}

static function string GetModifyArtilleryErrorString(EModifyArtilleryError ErrorType)
{
    switch (ErrorType)
    {
        case ERROR_Fatal:
            return "Fatal error!";

        case ERROR_IndexOutOfBounds:
            return "Specified artillery type index is out of bounds.";
    }
}

defaultproperties
{
    Texture=Texture'Engine.S_Trigger'
}
