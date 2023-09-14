//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class Period extends Object;

var int Years;
var int Months;
var int Weeks;
var int Days;
var int Hours;
var int Minutes;
var int Seconds;

static function Period FromSeconds(int Seconds)
{
    local Period P;

    P = new class'Period';

    P.Years = Seconds / 31536000;
    Seconds = Seconds % 31536000;

    return P;
}

function string IsoFormat()
{
    local string S;

    S = "P";

    S $= "T";

    return S;
}

