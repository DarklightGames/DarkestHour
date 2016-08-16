//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class UInteger extends Object;

var int Value;

static final function UInteger Create(optional int Value)
{
	local UInteger I;

	I = new class'UInteger';
	I.Value = Value;

	return I;
}
