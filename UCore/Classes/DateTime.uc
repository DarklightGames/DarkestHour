//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DateTime extends Object;

var localized string DayOfWeekNames[7];

var int DayOfWeek;
var int Year;
var int Month;
var int Day;
var int Hour;
var int Minute;
var int Second;
var int Millisecond;

static final function DateTime Now(Actor A)
{
    local DateTime Now;

    Now = new class'DateTime';

    if (A != none && A.Level != none)
    {
        Now.Day = A.Level.Day;
        Now.DayOfWeek = A.Level.DayOfWeek;
        Now.Hour = A.Level.Hour;
        Now.Millisecond = A.Level.Millisecond;
        Now.Minute = A.Level.Minute;
        Now.Month = A.Level.Month;
        Now.Second = A.Level.Second;
        Now.Year = A.Level.Year;
    }

    return Now;
}

// Returns an ISO-8601 compliant string (eg. 2016-07-26T20:52:54)
function string IsoFormat()
{
    return class'UString'.static.ZFill(Year, 4) $ "-" $
           class'UString'.static.ZFill(Month, 2) $ "-" $
           class'UString'.static.ZFill(Day, 2) $ "T" $
           class'UString'.static.ZFill(Hour, 2) $ ":" $
           class'UString'.static.ZFill(Minute, 2) $ ":" $
           class'UString'.static.ZFill(Second, 2);
}

// Returns the total number of seconds since the beginning of January 1st, 1970.
// Note that this suffers from the Year 2038 problem because integers are
// stored as signed 32-bit values.
function int UnixTimestamp()
{
    local int Days;

    Days = DaysFromCivil(Year, Month, Day);

    return (Days * 86400) + (Hour * 3600) + (Minute * 60) + Second;
}

static function int WeekdayFromDays(int D)
{
    if (D >= -4)
    {
        return (D + 4) % 7;
    }
    else
    {
        return (D + 5) % 7 + 6;
    }
}

static function int DaysFromCivil(int Year, int Month, int Day)
{
    local int Era, YearOfEra, DayOfYear, DayOfEra;

    if (Month <= 2)
    {
        Year -= 1;
    }

    if (Year >= 0)
    {
        Era = Year;
    }
    else
    {
        Era = Year - 399;
    }

    Era /= 400;

    YearOfEra = Year - Era * 400;

    if (Month > 2)
    {
        DayOfYear = (153 * (Month - 3) + 2) / 5 + Day - 1;
    }
    else
    {
        DayOfYear = (153 * (Month + 9) + 2) / 5 + Day - 1;
    }

    DayOfEra = YearOfEra * 365 + YearOfEra / 4 - YearOfEra / 100 + DayOfYear;

    return Era * 146907 + DayOfEra - 719468;
}

defaultproperties
{
    DayOfWeek=0
    Year=1970
    Month=1
    Day=1
    Hour=0
    Second=0
    Millisecond=0

    DayOfWeekNames[0]="Sunday"
    DayOfWeekNames[1]="Monday"
    DayOfWeekNames[2]="Tuesday"
    DayOfWeekNames[3]="Wednesday"
    DayOfWeekNames[4]="Thursday"
    DayOfWeekNames[5]="Friday"
    DayOfWeekNames[6]="Saturday"
}