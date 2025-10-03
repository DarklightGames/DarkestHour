//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class UMaterial extends Object
    abstract;

static function float AspectRatio(Material M)
{
    if (M != none)
    {
        return float(M.MaterialUSize()) / float(M.MaterialVSize());
    }

    return 0.0;
}

