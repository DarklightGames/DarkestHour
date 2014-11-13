//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHLevelSharedInfo extends Actor
    hidecategories(Object,Collision,Lighting,LightColor,Karma,Force,sound)
    placeable;

//Variables
var() byte SmokeBrightnessOverride; //Used to override the lighting brightness of smoke emitters
var() rangevector WindDirectionSpeed; //Used to make smoke grenades match other emitters in the level

//Other ideas
//date : to indicate when this level takes place, so we can properly assign correct variants of ammo etc.
//

DefaultProperties
{
    bHidden=true
    //RemoteRole=ROLE_none

    RemoteRole=ROLE_SimulatedProxy
    SmokeBrightnessOverride=255
    //AlliesWinsMusic=sound'DH_win.Allies.DH_AlliesGroup'
    //AxisWinsMusic=sound'DH_win.German.DH_GermanGroup'
}