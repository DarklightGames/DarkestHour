//==============================================================================
// Darklight Games (c) 2008-2017
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
