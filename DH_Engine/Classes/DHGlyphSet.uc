//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGlyphSet extends Object
    abstract;

struct Glyph
{
    var() string Character; // Make sure this is only a single character!
    var() Texture Material;
};

var() array<Glyph> Glyphs;
var() int GlyphFallbackIndex;   // Index of the fallback glyph to use if the requested glyph is not found, or -1 if no fallback should be used.

// Returns the material for the given character.
static function Texture GetGlyphMaterial(string Character)
{
    local int i;

    for (i = 0; i < default.Glyphs.Length; i++)
    {
        if (default.Glyphs[i].Character == Character)
        {
            return default.Glyphs[i].Material;
        }
    }

    if (default.GlyphFallbackIndex != -1)
    {
        return default.Glyphs[default.GlyphFallbackIndex].Material;
    }

    return none;
}

defaultproperties
{
    GlyphFallbackIndex=-1
}
