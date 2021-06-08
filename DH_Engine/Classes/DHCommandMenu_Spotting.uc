//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHCommandMenu_Spotting extends DHCommandMenu;

function Setup()
{
    local int i, J;
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    for (i = 0; i < arraycount(GRI.MapMarkerClasses); ++i)
    {
        if (GRI.MapMarkerClasses[i] != none && ClassIsChildOf(GRI.MapMarkerClasses[i], class'DHMapMarker_Enemy'))
        {
            Options.Insert(j, 1);
            Options[j].OptionalObject = GRI.MapMarkerClasses[i];
            Options[j].Material = GRI.MapMarkerClasses[i].default.IconMaterial;
            Options[j].SubjectText = GRI.MapMarkerClasses[i].default.MarkerName;
            Options[j].IconColor = GRI.MapMarkerClasses[i].default.IconColor;
            ++j;
        }
    }

    super.Setup();
}

function OnSelect(int OptionIndex, vector Location)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local class<DHMapMarker> MapMarkerClass;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    PC = GetPlayerController();

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    MapMarkerClass = class<DHMapMarker>(Options[OptionIndex].OptionalObject);

    if (GRI == none || PRI == none || MapMarkerClass == none)
    {
        return;
    }

    GRI.GetMapCoords(Location, MapLocation.X, MapLocation.Y);

    PC.ServerAddMapMarker(MapMarkerClass, MapLocation.X, MapLocation.Y, Location);

    Interaction.Hide();
}

function OnPush()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none)
    {
        return;
    }

    if (PC.SpottingMarker != none)
    {
        PC.SpottingMarker.Destroy();
    }

    PC.SpottingMarker = PC.Spawn(class'DHSpottingMarker', PC);
}

function OnPop()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    PC.SpottingMarker.Destroy();
}

function Tick()
{
    local DHPlayer PC;
    local vector HitLocation, HitNormal;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    PC.GetEyeTraceLocation(HitLocation, HitNormal);
    PC.SpottingMarker.SetLocation(HitLocation);
    PC.SpottingMarker.SetRotation(QuatToRotator(QuatFindBetween(HitNormal, vect(0, 0, 1))));
}

defaultproperties
{
    bShouldTick=true
}
