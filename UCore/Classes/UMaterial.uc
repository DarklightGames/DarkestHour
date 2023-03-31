//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

