//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ModifyRoundTimeMessage extends ROCriticalMessage
    notplaceable;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local   string              TimeString;

    // If for whatever reason there's no DH_RoundTimeModifier object passed in
    // we'll just dump the generic message.
    if (OptionalObject == none || DH_ModifyRoundTime(OptionalObject) == none)
        return "Round time has been modified.";

    CreateTimeString(TimeString, DH_ModifyRoundTime(OptionalObject).Seconds);

    switch (Int(DH_ModifyRoundTime(OptionalObject).RoundTimeOperator))
    {
        case 0:
            return "Round time has been increased by" @ TimeString $ ".";
        case 1:
            return "Round time has been decreased by" @ TimeString $ ".";
        case 2:
            return "Round time has been set to" @ TimeString $ ".";
        default:
            return "Round time has been modified.";
    }
}

static simulated function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if (OptionalObject == none || DH_ModifyRoundTime(OptionalObject) == none || !DH_ModifyRoundTime(OptionalObject).bPlaySound)
        return;

    P.PlayAnnouncement(DH_ModifyRoundTime(OptionalObject).Sound, 1, true);
}

static function CreateTimeString(out string TimeString, int Seconds)
{
    local   int                 Hours;
    local   int                 Minutes;

    if (Seconds >= 3600)
    {
        Hours = Seconds / 3600;
        Seconds = Seconds % 3600;
    }

    //Minutes
    if (Seconds >= 60)
    {
        Minutes = Seconds / 60;
        Seconds = Seconds % 60;
    }

    if (Hours > 0)
    {
        TimeString @= Hours @ "hour";

        if (Hours > 1)
            TimeString $= "s";
    }

    if (Minutes > 0)
    {
        TimeString @= Minutes @ "minute";

        if (Minutes > 1)
            TimeString $= "s";
    }

    if (Seconds > 0)
    {
        TimeString @= Seconds @ "second";

        if (Seconds > 1)
            TimeString $= "s";
    }

    Trim(TimeString);
}

static final function LeftTrim(out string S)
{
    while(Left(S, 1) == " ")
        S = Right(S, Len(S) - 1);
}

static final function RightTrim(out string S)
{
    while(Right(S, 1) == " ")
        S = Left(S, Len(S) - 1);
}

static final function Trim(out string S)
{
    LeftTrim(S);
    RightTrim(S);
}

defaultproperties
{
}
