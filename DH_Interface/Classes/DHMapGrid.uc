//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Grids are used for player-to-player communication for marking locations on
// the map. (e.g. "Enemy tank spotted at grid A3K8").
//
// The grid is laid out as a 9x9 grid of squares.
// Columns are labeled A though I, and rows are labeled 1 through 9.
// The top left square is A1, and the bottom right square is I9.
// Each square is further subdivided into a 3x3 grid of smaller squares.
// These smaller squares are referred to as the "keypad" coordinate, because the
// order mirrors the layout of a numeric keypad on most keyboards:
// 7 8 9
// 4 5 6
// 1 2 3
//==============================================================================

class DHMapGrid extends Object
    abstract;

struct GridCoordinate
{
    var byte Column;
    var byte Row;
    var byte Keypad;    // If 0, then the entire square is being referred to.
};

static function string GetGridCoordinateToString(GridCoordinate Coordinate)
{
    local string String;

    String = Chr(Asc("A") + Coordinate.Row) $ (1 + Coordinate.Column);

    if (Coordinate.Keypad > 0)
    {
        String $= "K" $ Coordinate.Keypad;
    }

    return String;
}

static function GridCoordinate GetGridCoordinateFromString(string CoordinateString)
{
    local GridCoordinate Coordinate;

    if (Len(CoordinateString) >= 2)
    {
        Coordinate.Column = Clamp(Asc(Left(CoordinateString, 1)) - Asc("A"), 0, 8);
        Coordinate.Row = Clamp(Asc(Mid(CoordinateString, 1, 1)) - Asc("1"), 0, 8);
    }

    if (Len(CoordinateString) >= 3)
    {
        Coordinate.Keypad = Clamp(Asc(Mid(CoordinateString, 2, 1)) - Asc("1"), 1, 9);
    }

    return Coordinate;
}

static function GridCoordinate GetGridCoordinatesFromWorldLocation(DHGameReplicationInfo GRI, Vector WorldLocation, optional bool bIncludeKeypad)
{
    local GridCoordinate Coordinate;
    local float X, Y;
    
    GRI.GetMapCoords(WorldLocation, X, Y);

    X = FClamp(X, 0.0, 1.0);
    Y = FClamp(Y, 0.0, 1.0);

    Coordinate.Column = byte(X * 9);
    Coordinate.Row = byte(Y * 9);

    if (bIncludeKeypad)
    {
        X = byte(X * 27) % 3;
        Y = byte(Y * 27) % 3;
        Coordinate.Keypad = 1 + X + (2 - Y) * 3;
    }

    return Coordinate;
}

// Returns the grid coordinate from untranslated normalized map coordinates (0.0 to 1.0).
static function GridCoordinate GetGridCoordinatesFromMapCoordinates(DHGameReplicationInfo GRI, float X, float Y, optional bool bIncludeKeypad)
{
    return GetGridCoordinatesFromWorldLocation(GRI, GRI.GetWorldCoords(X, Y), bIncludeKeypad);
}

static function int GridCoordinateCompress(GridCoordinate Coordinate)
{
    return class'UInteger'.static.FromBytes(Coordinate.Column, Coordinate.Row, Coordinate.Keypad);
}

static function GridCoordinate GridCoordinateDecompress(int Compressed)
{
    local GridCoordinate Coordinate;
    class'UInteger'.static.ToBytes(Compressed, Coordinate.Column, Coordinate.Row, Coordinate.Keypad);
    return Coordinate;
}
