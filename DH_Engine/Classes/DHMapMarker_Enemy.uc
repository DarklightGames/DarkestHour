//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapMarker_Enemy extends DHMapMarker
    abstract;

// Gets the percentage of this marker's lifetime that has elapsed,
// where 0.0 is the beginning of life and 1.0 is the end of life.
static function float GetMapMarkerLifetimePercent(int ElapsedTime, DHGameReplicationInfo.MapMarker Marker)
{
    return float(ElapsedTime - Marker.CreationTime) / (Marker.ExpiryTime - Marker.CreationTime);
}

// Modified to fade the marker out over time.
static function Color GetIconColor(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local Color C;
    local float T, MinA;
    local int ElapsedTime;

    C = default.IconColor;

    ElapsedTime = DHGameReplicationInfo(PC.GameReplicationInfo).ElapsedTime;
    T = GetMapMarkerLifetimePercent(ElapsedTime, Marker);

    if (T < 0.25)
    {
        C.A = 255;
    }
    else if (T > 0.75)
    {
        C.A = 64;
    }
    else
    {
        T = (T - 0.25) * 2.0;
        C.A = class'UInterp'.static.Linear(T, 1.0, 0.25) * 255;
    }

    return C;
}

defaultproperties
{
    IconColor=(R=255,G=0,B=0,A=255)
    GroupIndex=1
    Type=MT_Enemy
    Scope=TEAM
    OverwritingRule=OFF
    Permissions_CanSee(0)=(LevelSelector=TEAM,RoleSelector=ERS_ALL)
    Permissions_CanRemove(0)=(LevelSelector=TEAM,RoleSelector=ERS_SL)
    Permissions_CanRemove(1)=(LevelSelector=TEAM,RoleSelector=ERS_ASL)
    Permissions_CanRemove(2)=(LevelSelector=TEAM,RoleSelector=ERS_PATRON)
    Permissions_CanPlace(0)=ERS_SL
    Permissions_CanPlace(1)=ERS_ASL
    Permissions_CanPlace(2)=ERS_PATRON
}
