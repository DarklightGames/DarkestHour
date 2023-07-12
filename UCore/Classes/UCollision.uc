//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class UCollision extends Object;

enum ECollisionType
{
    CT_Disjoint,
    CT_Intersect,
    CT_Contain,
    CT_Parallel
};

static function bool PointInCylinder(vector Origin, float Radius, float HalfHeight, rotator Rotation, vector Point)
{
    Point = (Point - Origin) << Rotation;
    return Sqrt(Point.X * Point.X + Point.Y * Point.Y) < Radius && Abs(Point.Z) < HalfHeight;
}

final private static function byte ComputeOutCode(float X, float Y, Box Viewport)
{
    local byte Code;

    const CODE_INSIDE = 0;
    const CODE_LEFT = 1;
    const CODE_RIGHT = 2;
    const CODE_BOTTOM = 4;
    const CODE_TOP = 8;

    if (X < Viewport.Min.X)
    {
        // to the left of clip window
        Code = Code | CODE_LEFT;
    }
    else if (X > Viewport.Max.X)
    {
        // to the right of clip window
        Code = Code | CODE_RIGHT;
    }

    if (Y < Viewport.Min.Y)
    {
        // below the clip window
        Code = Code | CODE_BOTTOM;
    }
    else if (Y > Viewport.Max.Y)
    {
        // above the clip window
        Code = Code | CODE_TOP;
    }

    return Code;
}

// Uses the Cohen-Sutherland algorithm to clip a line within a 2D viewport.
// Returns true when the line is contained within or intersects the viewport.
// When the function returns true, the vertex locations ((@X0, @Y0) (@X1, @Y1))
// are modified to be clipped within the viewport.
final static function bool ClipLineToViewport(out float X0, out float Y0, out float X1, out float Y1, Box Viewport)
{
    // compute OutCodes for P0, P1, and whatever point lies outside the clip rectangle
    local byte OutCode0, OutCode1, OutCodeOut;
    local bool bAccept;
    local float X, Y;

    OutCode0 = ComputeOutCode(X0, Y0, Viewport);
    OutCode1 = ComputeOutCode(X1, Y1, Viewport);

    while (true)
    {
        if ((OutCode0 | OutCode1) == 0)
        {
            // bitwise OR is 0: both points inside window; trivially accept and exit loop
            bAccept = true;
            break;
        }
        else if ((OutCode0 & OutCode1) != 0)
        {
            // bitwise AND is not 0: both points share an outside zone (LEFT, RIGHT, TOP,
            // or BOTTOM), so both must be outside window; exit loop (accept is false)
            break;
        }
        else
        {
            // failed both tests, so calculate the line segment to clip
            // from an outside point to an intersection with clip edge

            // At least one endpoint is outside the clip rectangle; pick it.
            if (OutCode0 != 0)
            {
                OutCodeOut = OutCode0;
            }
            else
            {
                OutCodeOut = OutCode1;
            }

            // Now find the intersection point;
            // use formulas:
            //   slope = (Y1 - Y0) / (X1 - X0)
            //   x = X0 + (1 / slope) * (ym - Y0), where ym is ymin or ymax
            //   y = Y0 + slope * (xm - X0), where xm is xmin or xmax
            // No need to worry about divide-by-zero because, in each case, the
            // OutCode bit being tested guarantees the denominator is non-zero
            if ((OutCodeOut & CODE_TOP) != 0)
            {
                // point is above the clip window
                X = X0 + (X1 - X0) * (Viewport.Max.Y - Y0) / (Y1 - Y0);
                Y = Viewport.Max.Y;
            }
            else if ((OutCodeOut & CODE_BOTTOM) != 0)
            {
                // point is below the clip window
                X = X0 + (X1 - X0) * (Viewport.Min.Y - Y0) / (Y1 - Y0);
                Y = Viewport.Min.Y;
            }
            else if ((OutCodeOut & CODE_RIGHT) != 0)
            {
                // point is to the right of clip window
                Y = Y0 + (Y1 - Y0) * (Viewport.Max.X - X0) / (X1 - X0);
                X = Viewport.Max.X;
            }
            else if ((OutCodeOut & CODE_LEFT) != 0)
            {
                // point is to the left of clip window
                Y = Y0 + (Y1 - Y0) * (Viewport.Min.X - X0) / (X1 - X0);
                X = Viewport.Min.X;
            }

            // Now we move outside point to intersection point to clip
            // and get ready for next pass.
            if (OutCodeOut == OutCode0)
            {
                X0 = X;
                Y0 = Y;
                OutCode0 = ComputeOutCode(X0, Y0, Viewport);
            }
            else
            {
                X1 = X;
                Y1 = Y;
                OutCode1 = ComputeOutCode(X1, Y1, Viewport);
            }
        }
    }

    return bAccept;
}
