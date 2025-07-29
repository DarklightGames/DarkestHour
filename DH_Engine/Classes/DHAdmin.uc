//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAdmin extends AdminIni;

function DoLoginSilent( string Username, string Password)
{
    if (Level.Game.AccessControl.AdminLoginSilent(Outer, Username, Password))
    {
        bAdmin = true;
        Outer.ReceiveLocalizedMessage(Level.Game.GameMessageClass, 20);
    }
}
