//=============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//=============================================================================
// This is all a bit of a hack until we can come up with a better solution.
// We need to be able to reset the dirt color of the wheel dust effect when
// the dirt color on the level is set to black (which is the default, unchanged
// on every level).
//=============================================================================

class DHVehicleWheelDustEffect extends VehicleWheelDustEffect;

simulated function ResetDirtColor()
{
    local int i;

    for (i = 0; i < Emitters[0].ColorScale.Length; i++)
    {
        Emitters[0].ColorScale[i].Color = default.Emitters[0].ColorScale[i].Color;
    }
}

simulated function SetDirtColor(Color DirtColor)
{
    local int i, j;

    if (DirtColor.R == 0 && DirtColor.G == 0 && DirtColor.B == 0)
    {
        ResetDirtColor();
        return;
    }

    super.SetDirtColor(DirtColor);
}
