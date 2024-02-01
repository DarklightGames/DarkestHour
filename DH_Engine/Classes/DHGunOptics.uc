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

static function DrawGunsightOverlay(Canvas C, int Range, optional int RangeTableIndex);

defaultproperties
{
    GunsightSize=0.5
}
