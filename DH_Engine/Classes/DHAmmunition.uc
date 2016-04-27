//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHAmmunition extends ROAmmunition
    abstract;

// Colin: used by DHRoleSelectPanel to override image for sniper rifles that
// show singular bullet on main HUD, but need to display the stripper clip
// on the menu
var Material    MenuImage;

defaultproperties
{
    IconCoords=(X1=445,Y1=75,X2=544,Y2=149)
}
