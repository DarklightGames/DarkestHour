//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHArtilleryRequest extends Object;

var int                 TeamIndex;
var int                 ArtilleryTypeIndex;
var Vector              Location;
var DHPlayer            Sender; // TODO: objects holding refs to actors = bad news, use ROID?

simulated function class<DHArtillery> GetArtilleryClass()
{
    return Sender.GetLevelInfo().ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass;
}
