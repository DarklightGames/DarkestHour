//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class UVector extends Object
    abstract;

static final function vector RandomRange(rangevector Range)
{
    local vector V;

    V.X = class'UFloat'.static.RandomRange(Range.X.Min, Range.X.Max);
    V.Y = class'UFloat'.static.RandomRange(Range.Y.Min, Range.Y.Max);
    V.Z = class'UFloat'.static.RandomRange(Range.Z.Min, Range.Z.Max);

    return V;
}

static final function float MaxElement(vector V)
{
    return FMax(V.X, FMax(V.Y, V.Z));
}

static final function float MinElement(vector V)
{
    return FMin(V.X, FMin(V.Y, V.Z));
}

static final function vector VLerp(float T, vector Start, vector End)
{
    return Start + ((End - Start) * T);
}

static final function vector MinComponent(vector A, vector B)
{
    local vector V;

    V.X = FMin(A.X, B.X);
    V.Y = FMin(A.Y, B.Y);
    V.Z = FMin(A.Z, B.Z);

    return V;
}

static final function vector MaxComponent(vector A, vector B)
{
    local vector V;

    V.X = FMax(A.X, B.X);
    V.Y = FMax(A.Y, B.Y);
    V.Z = FMax(A.Z, B.Z);

    return V;
}

static final function float SignedAngle(vector From, vector To, vector PlaneNormal)
{
    return ATan((From cross To) dot PlaneNormal, From dot To);
}

static function float InverseSquareLaw(vector PointA, vector PointB)
{
    return 1.0 / FMax(VSizeSquared(PointA - PointB), class'UFloat'.static.Epsilon());
}

static final function LinearRegression(array<vector> Points, out vector A, out vector B)
{
    local int NPoints;
    local float SumX, SumX2, SumY, XBar, YBar, XXBar, YYBar, XYBar, Theta, Intercept;
    local array<float> Products;
    local vector Forward;
    local int i;

    NPoints = Points.Length;

    if (NPoints <= 1)
    {
        return;
    }

    if (NPoints == 2)
    {
        A = Points[0];
        B = Points[1];
        return;
    }

    for (i = 0; i < Points.Length; ++i)
    {
        SumX += Points[i].X;
        SumX2 += Points[i].X ** 2;
        SumY += Points[i].Y;
    }

    XBar = SumX / NPoints;
    YBar = SumY / NPoints;

    for (i = 0; i < Points.Length; ++i)
    {
        XXBar += (Points[i].X - XBar) * (Points[i].X - XBar);
        YYBar += (Points[i].Y - YBar) * (Points[i].Y - YBar); // ?
        XYBar += (Points[i].X - XBar) * (Points[i].Y - YBar);
    }

    Intercept = YBar - (XYBar / XXBar) * XBar;

    // Get the direction vector
    Theta = ATan(XYBar, XXBar);
    Forward.X = Cos(Theta);
    Forward.Y = Sin(Theta);

    // Flatten the field, truncate all points down by the intercept, and get the
    // dot-products of the direction vector and each point
    for (i = 0; i < Points.Length; ++i)
    {
        Points[i].Z = 0;
        Points[i].Y -= Intercept;
        Products[Products.Length] = Points[i] dot Forward;
    }

    // TODO: Use something simpler to find the min-max
    class'UHeap_float'.static.Heapsort(Products);

    // Get the starting and ending point of the line
    A = Forward * Products[0]; // min
    B = Forward * Products[Products.Length - 1]; // max

    // Translate these points up by the original intercept
    A.Y += Intercept;
    B.Y += Intercept;
}
