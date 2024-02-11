//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGunOptics extends Object;

var array<DHGunOpticsRangeTable> OpticalRangeTables;

var Material GunsightOverlay;
var Material CannonScopeCenter;
var float GunsightSize;
var float OverlayCorrectionX;
var float OverlayCorrectionY;

static function DrawGunsightOverlay(Canvas C, int Range, optional int RangeTableIndex)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, PosX, PosY;
    local float GunsightWidthPixels;

    if (default.GunsightOverlay == none)
    {
        return;
    }

    // Draw the gunsight overlay.
    TextureSize = float(default.GunsightOverlay.MaterialUSize());
    TilePixelWidth = TextureSize / default.GunsightSize;
    TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
    TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - default.OverlayCorrectionX;
    TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - default.OverlayCorrectionY;

    C.SetPos(0.0, 0.0);
    C.DrawTile(default.GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
}

defaultproperties
{
    GunsightSize=0.5
}
