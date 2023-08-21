//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M9531Bullet extends DHBullet;  //8x56R

defaultproperties
{
    Speed=37418.24              // 700m/s (http://www.hungariae.com/Mann31.htm)
    BallisticCoefficient=0.515  //to do: find the real one (this is taken from kar98)
    Damage=114.0                
    MyDamageType=class'DH_Weapons.DH_M9531DamType'
}