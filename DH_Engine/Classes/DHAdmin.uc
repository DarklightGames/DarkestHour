//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
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

defaultproperties
{

}
