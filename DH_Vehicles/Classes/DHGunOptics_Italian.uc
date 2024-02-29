//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGunOptics_Italian extends DHGunOptics;

static function DrawGunsightOverlay(Canvas C, int Range, optional int RangeTableIndex)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, PosY;
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

    // Draw the gunsight aiming reticle or moving range indicator (different from DHVehicleCannonPawn)
    if (default.CannonScopeCenter != none)
    {
        // The y-adjust should be defined in the gunsight, not on the shell, at least for this type, but for expediency we can just continue the madness.
        PosY = 0.5 - default.OpticalRangeTables[RangeTableIndex].GetRangeValue(Range); // TODO: we need to know which table to use based on the shell.
        GunsightWidthPixels = C.SizeX * default.GunsightSize;
        PosY = GunsightWidthPixels * PosY;

        C.SetPos(0, PosY);
        C.DrawTile(default.CannonScopeCenter, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

defaultproperties
{
    // AP/APBC range table
    Begin Object Class=DHGunOpticsRangeTable Name=RangeTable1
        RangeValues(0)=(Range=0,Value=0.5)
        RangeValues(1)=(Range=200,Value=0.520)
        RangeValues(2)=(Range=400,Value=0.536)
        RangeValues(3)=(Range=600,Value=0.552)
        RangeValues(4)=(Range=800,Value=0.568)
        RangeValues(5)=(Range=1000,Value=0.583)
        RangeValues(6)=(Range=1200,Value=0.601)
        RangeValues(7)=(Range=1400,Value=0.620)
        RangeValues(8)=(Range=1600,Value=0.638)
        RangeValues(9)=(Range=1800,Value=0.659)
        RangeValues(10)=(Range=2000,Value=0.678)
    End Object
    OpticalRangeTables(0)=RangeTable1

    // HE/HEAT range table
    Begin Object Class=DHGunOpticsRangeTable Name=RangeTable2
        RangeValues(0)=(Range=100,Value=0.5)
        RangeValues(1)=(Range=200,Value=0.523)
        RangeValues(2)=(Range=300,Value=0.532)
        RangeValues(3)=(Range=400,Value=0.542)
        RangeValues(4)=(Range=500,Value=0.554)
        RangeValues(5)=(Range=600,Value=0.567)
        RangeValues(6)=(Range=700,Value=0.580)
        RangeValues(7)=(Range=800,Value=0.593)
        RangeValues(8)=(Range=900,Value=0.607)
        RangeValues(9)=(Range=1000,Value=0.619)
        RangeValues(10)=(Range=1100,Value=0.635)
        RangeValues(11)=(Range=1200,Value=0.652)
        RangeValues(12)=(Range=1300,Value=0.667)
        RangeValues(13)=(Range=1400,Value=0.683)
        RangeValues(14)=(Range=1500,Value=0.702)
        RangeValues(15)=(Range=1600,Value=0.717)
        RangeValues(16)=(Range=1700,Value=0.734)
        RangeValues(17)=(Range=1800,Value=0.752)
        RangeValues(18)=(Range=1900,Value=0.770)
        RangeValues(19)=(Range=2000,Value=0.789)
    End Object
    OpticalRangeTables(1)=RangeTable2

    GunsightSize=0.4
    GunsightOverlay=Texture'DH_Semovente9053_tex.Interface.semovente9053_sight_background'
    CannonScopeCenter=Texture'DH_Semovente9053_tex.interface.semovente9053_sight_mover'
}