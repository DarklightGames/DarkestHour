//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtilleryRequest extends Object;

var int                 TeamIndex;
var int                 ArtilleryTypeIndex;
var vector              Location;
var DHPlayer            Sender; // TODO: objects holding refs to actors = bad news, use ROID?

simulated function class<DHArtillery> GetArtilleryClass()
{
    return Sender.GetLevelInfo().ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass;
}
