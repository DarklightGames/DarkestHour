//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class UQuantize extends Object;

static function byte QuantizeRotationUnit(int R)
{
    return 255 * (float(R) / 65536);
}

static function int DequantizeRotationUnit(byte R)
{
    return 65536 * (float(R) / 255);
}

// Returns the quantized representation of a clamped (0.0...1.0) floating point
// number given a bit-precision.
// For example, a Value of 0.75 and Precision of 4 (0..15) would return 11.
static function int QuantizeClampedFloat(float Value, byte Precision)
{
    return int(Value * ((1 << Precision) - 1));
}

// Returns the dequantized representation of a clamped floating point number
// [0.0...1.0], given an integer value and a bit-precision.
// For example, a Value of 11 and a Precision of 4 would return ~0.74.
static function float DequantizeClampedFloat(int Value, byte Precision)
{
    return float(Value) / ((1 << Precision) - 1);
}

// Returns a quantized representation of a 2-dimensional pose (location and
// rotation). 12 bits of precision are used for each location component, and 8
// bits of precision are used for the rotation component.
static function int QuantizeClamped2DPose(float X, float Y, int Rotation)
{
    return QuantizeRotationUnit(Rotation) |
           QuantizeClampedFloat(Y, 12) << 8 |
           QuantizeClampedFloat(X, 12) << 20;
}

static function DequantizeClamped2DPose(int Value, optional out float X, optional out float Y, optional out int Rotation)
{
    Y = DequantizeClampedFloat((Value >> 8) & 0xFFF, 12);
    X = DequantizeClampedFloat((Value >> 20) & 0xFFF, 12);
    Rotation = DequantizeRotationUnit(Value & 0xFF);
}

