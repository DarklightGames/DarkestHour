//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class TimeSpan extends Object;

const SECONDS_PER_HOUR = 3600;
const SECONDS_PER_MINUTE = 60;

var private int _TotalSeconds;
var private int _Seconds;
var private int _Minutes;
var private int _Hours;

function int TotalSeconds()
{
    return _TotalSeconds;
}

function int Seconds()
{
    return _Seconds;
}

function int Minutes()
{
    return _Minutes;
}

function int Hours()
{
    return _Hours;
}

function static TimeSpan FromSeconds(int TotalSeconds)
{
    local TimeSpan TS;

    TS._TotalSeconds = TotalSeconds;

    Decompose(TotalSeconds, TS._Hours, TS._Minutes, TS._Seconds);

    return TS;
}

function static Decompose(int TotalSeconds, out int Hours, out int Minutes, out int Seconds)
{
    Seconds = TotalSeconds;

    Hours   = Seconds / SECONDS_PER_HOUR;
    Seconds = Seconds % SECONDS_PER_HOUR;

    Minutes = Seconds / SECONDS_PER_MINUTE;
    Seconds = Seconds % SECONDS_PER_MINUTE;
}

function static string ToString(int TotalSeconds)
{
    local string S;
    local int Hours, Minutes, Seconds;

    Decompose(TotalSeconds, Hours, Minutes, Seconds);

    if (Hours > 0)
    {
        S $= Hours $ ":";
    }

    S $= class'UString'.static.ZFill(Minutes, 2) $ ":" $ class'UString'.static.ZFill(Seconds, 2);

    return S;
}

function TimeSpan Add(TimeSpan Other)
{
    return FromSeconds(self._TotalSeconds + Other._TotalSeconds);
}

function TimeSpan Subtract(TimeSpan Other)
{
    return FromSeconds(self._TotalSeconds - Other._TotalSeconds);
}

function int Compare(TimeSpan Other)
{
    if (self._TotalSeconds > Other._TotalSeconds)
    {
        return 1;
    }
    else if (self._TotalSeconds < Other._TotalSeconds)
    {
        return -1;
    }
    else
    {
        return 0;
    }
}
