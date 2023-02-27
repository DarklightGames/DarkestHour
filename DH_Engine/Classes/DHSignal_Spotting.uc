//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSignal_Spotting extends DHSignal
    abstract;

static function Material GetWorldIconMaterial(optional Object OptionalObject)
{
    local class<DHMapMarker> MapMarkerClass;
    
    MapMarkerClass = class<DHMapMarker>(OptionalObject);

    if (MapMarkerClass != none)
    {
        return MapMarkerClass.default.IconMaterial;
    }
    else
    {
        return super.GetWorldIconMaterial(OptionalObject);
    }
}

static function Color GetColor(optional Object OptionalObject)
{
    local class<DHMapMarker> MapMarkerClass;
    
    MapMarkerClass = class<DHMapMarker>(OptionalObject);

    if (MapMarkerClass != none)
    {
        return MapMarkerClass.default.IconColor;
    }
    else
    {
        return super.GetColor(OptionalObject);
    }
}

static function OnSent(DHPlayer PC, vector Location, optional Object OptionalObject)
{
    local class<DHMapMarker> MapMarkerClass;

    if (PC == none)
    {
        return;
    }
    
    MapMarkerClass = class<DHMapMarker>(OptionalObject);

    if (MapMarkerClass != none && MapMarkerClass.default.SpottingConsoleCommand != "")
    {
        // Send the associated console command for this map marker.
        PC.ConsoleCommand(MapMarkerClass.default.SpottingConsoleCommand);
    }
}

defaultproperties
{
    bIsUnique=true
    DurationSeconds=5.0
    WorldIconScale=0.75
}
