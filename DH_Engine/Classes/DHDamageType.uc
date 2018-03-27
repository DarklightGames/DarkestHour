//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHDamageType extends DamageType;

var()   class<Weapon>               WeaponClass;

var     Material                    HUDIcon;
var     float                       TankDamageModifier;                 // Tank damage
var     float                       APCDamageModifier;                  // HT type vehicle damage
var     float                       VehicleDamageModifier;              // Standard vehicle damage
var     float                       HighExplosiveDirectHitModifier;     // If vehicle is vulnerable to HE apply this modifier (gets applied on top of other modifiers)
var     float                       TreadDamageModifier;                // Tank Tread damage
var     bool                        bCauseViewJarring;                  // Causes the player to be 'struck' and shake
var     bool                        bIsHighExplosiveDamage;             // Bool that indicates the damage type is high explosive

static function string GetWeaponClass()
{
    return string(default.WeaponClass);
}

static function bool IsWeaponDamage()
{
    if (default.WeaponClass != none)
    {
        return true;
    }

    return false;
}

defaultproperties
{
    WeaponClass=none
    HUDIcon=Texture'InterfaceArt_tex.deathicons.Generic'
    bKUseOwnDeathVel=True

    TankDamageModifier=0.0
    APCDamageModifier=0.0
    VehicleDamageModifier=0.10
    HighExplosiveDirectHitModifier=1.0
    TreadDamageModifier=0.0
    bExtraMomentumZ=false
    bCauseViewJarring = false;
}
