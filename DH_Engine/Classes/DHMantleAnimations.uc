//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
//  TODO: Convert to array with associated height and animation instead of
//  individual variables.
//==============================================================================

class DHMantleAnimations extends Object
    abstract;

// Mantling
var(ROAnimations)   name        MantleAnim_40C, MantleAnim_44C, MantleAnim_48C, MantleAnim_52C, MantleAnim_56C, MantleAnim_60C, MantleAnim_64C,
                                MantleAnim_68C, MantleAnim_72C, MantleAnim_76C, MantleAnim_80C, MantleAnim_84C, MantleAnim_88C;

var(ROAnimations)   name        MantleAnim_40S, MantleAnim_44S, MantleAnim_48S, MantleAnim_52S, MantleAnim_56S, MantleAnim_60S, MantleAnim_64S,
                                MantleAnim_68S, MantleAnim_72S, MantleAnim_76S, MantleAnim_80S, MantleAnim_84S, MantleAnim_88S;

static function name GetMantleAnimation(bool bCrouchMantle, float MantleHeight)
{
    local name MantleAnim;

    if (bCrouchMantle)
    {
        if (MantleHeight > 84.0)
        {
            MantleAnim = default.MantleAnim_88C;
        }
        else if (MantleHeight > 80.0)
        {
            MantleAnim = default.MantleAnim_84C;
        }
        else if (MantleHeight > 76.0)
        {
            MantleAnim = default.MantleAnim_80C;
        }
        else if (MantleHeight > 72.0)
        {
            MantleAnim = default.MantleAnim_76C;
        }
        else if (MantleHeight > 68.0)
        {
            MantleAnim = default.MantleAnim_72C;
        }
        else if (MantleHeight > 64.0)
        {
            MantleAnim = default.MantleAnim_68C;
        }
        else if (MantleHeight > 60.0)
        {
            MantleAnim = default.MantleAnim_64C;
        }
        else if (MantleHeight > 56.0)
        {
            MantleAnim = default.MantleAnim_60C;
        }
        else if (MantleHeight > 52.0)
        {
            MantleAnim = default.MantleAnim_56C;
        }
        else if (MantleHeight > 48.0)
        {
            MantleAnim = default.MantleAnim_52C;
        }
        else if (MantleHeight > 44.0)
        {
            MantleAnim = default.MantleAnim_48C;
        }
        else if (MantleHeight > 40.0)
        {
            MantleAnim = default.MantleAnim_44C;
        }
        else
        {
            MantleAnim = default.MantleAnim_40C;
        }
    }
    else
    {
        if (MantleHeight > 84.0)
        {
            MantleAnim = default.MantleAnim_88S;
        }
        else if (MantleHeight > 80.0)
        {
            MantleAnim = default.MantleAnim_84S;
        }
        else if (MantleHeight > 76.0)
        {
            MantleAnim = default.MantleAnim_80S;
        }
        else if (MantleHeight > 72.0)
        {
            MantleAnim = default.MantleAnim_76S;
        }
        else if (MantleHeight > 68.0)
        {
            MantleAnim = default.MantleAnim_72S;
        }
        else if (MantleHeight > 64.0)
        {
            MantleAnim = default.MantleAnim_68S;
        }
        else if (MantleHeight > 60.0)
        {
            MantleAnim = default.MantleAnim_64S;
        }
        else if (MantleHeight > 56.0)
        {
            MantleAnim = default.MantleAnim_60S;
        }
        else if (MantleHeight > 52.0)
        {
            MantleAnim = default.MantleAnim_56S;
        }
        else if (MantleHeight > 48.0)
        {
            MantleAnim = default.MantleAnim_52S;
        }
        else if (MantleHeight > 44.0)
        {
            MantleAnim = default.MantleAnim_48S;
        }
        else if (MantleHeight > 40.0)
        {
            MantleAnim = default.MantleAnim_44S;
        }
        else
        {
            MantleAnim = default.MantleAnim_40S;
        }
    }

    return MantleAnim;
}

defaultproperties
{
    MantleAnim_40C="mantle_crouch_40"
    MantleAnim_44C="mantle_crouch_44"
    MantleAnim_48C="mantle_crouch_48"
    MantleAnim_52C="mantle_crouch_52"
    MantleAnim_56C="mantle_crouch_56"
    MantleAnim_60C="mantle_crouch_60"
    MantleAnim_64C="mantle_crouch_64"
    MantleAnim_68C="mantle_crouch_68"
    MantleAnim_72C="mantle_crouch_72"
    MantleAnim_76C="mantle_crouch_76"
    MantleAnim_80C="mantle_crouch_80"
    MantleAnim_84C="mantle_crouch_84"
    MantleAnim_88C="mantle_crouch_88"
    MantleAnim_40S="mantle_stand_40"
    MantleAnim_44S="mantle_stand_44"
    MantleAnim_48S="mantle_stand_48"
    MantleAnim_52S="mantle_stand_52"
    MantleAnim_56S="mantle_stand_56"
    MantleAnim_60S="mantle_stand_60"
    MantleAnim_64S="mantle_stand_64"
    MantleAnim_68S="mantle_stand_68"
    MantleAnim_72S="mantle_stand_72"
    MantleAnim_76S="mantle_stand_76"
    MantleAnim_80S="mantle_stand_80"
    MantleAnim_84S="mantle_stand_84"
    MantleAnim_88S="mantle_stand_88"
}