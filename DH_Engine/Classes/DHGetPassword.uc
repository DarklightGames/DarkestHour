//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGetPassword extends UT2K4GetPassword;

function RetryPassword()
{
    local string            EntryString;
    local ExtendedConsole   MyConsole;

    EntryString = ed_Data.GetText();
    MyConsole = ExtendedConsole(PlayerOwner().Player.Console);

    if ( MyConsole != None && EntryString != "" )
        SavePassword(MyConsole, EntryString);

    if (EntryString != "")
    {
        PlayerOwner().ClientTravel(RetryURL $ "?password=" $ EntryString, TRAVEL_Absolute, false);
    }
    else
    {
        PlayerOwner().ClientTravel(RetryURL, TRAVEL_Absolute, false);
    }

    Controller.CloseAll(false, true);
}
