//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class UFloat extends Object;

var float Value;

static final function UFloat Create(optional float Value)
{
	local UFloat F;

	F = new class'UFloat';
	F.Value = Value;

	return F;
}
