//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGunOptics extends Object;

var array<DHGunOpticsRangeTable> OpticalRangeTables;

var Material GunsightOverlay;
var Material CannonScopeCenter;
var float GunsightSize;

static function DrawGunsightOverlay(Canvas C, int Range, float OverlayCorrectionX, float OverlayCorrectionY, optional int RangeTableIndex)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (default.GunsightOverlay == none)
    {
        return;
    }

    // Draw the gunsight overlay.
    TextureSize = float(default.GunsightOverlay.MaterialUSize());
    TilePixelWidth = TextureSize / default.GunsightSize;
    TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
    TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
    TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;

    C.SetPos(0.0, 0.0);
    C.DrawTile(default.GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
}

defaultproperties
{
    GunsightSize=0.5
}
