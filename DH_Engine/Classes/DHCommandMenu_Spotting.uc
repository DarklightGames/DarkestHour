//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
        if (GRI.MapMarkerClasses[i] != none && GRI.MapMarkerClasses[i].default.Type == MT_Enemy)
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

function OnSelect(int OptionIndex, Vector Location, optional Vector HitNormal)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local class<DHMapMarker> MapMarkerClass;
    local DHGameReplicationInfo GRI;
    local Vector MapLocation;

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

    PC.AddMarker(MapMarkerClass, MapLocation.X, MapLocation.Y, Location);
    
    PC.ServerSignal(Class'DHSignal_Spotting', Location, MapMarkerClass);

    Interaction.Hide();
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker> MapMarkerClass;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(GetPlayerController().GameReplicationInfo);
    MapMarkerClass = class<DHMapMarker>(Options[OptionIndex].OptionalObject);

    return GRI == none || (MapMarkerClass != none && !MapMarkerClass.static.CanBeUsed(GRI));
}

function Tick()
{
    local DHPlayer PC;
    local Vector HitLocation, HitNormal;

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
    bUsesSpottingMarker=true
}
