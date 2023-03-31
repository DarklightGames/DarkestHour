//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================

class JSONNumber extends JSONValue;

var private string Value;

function string AsString()
{
    return Value;
}

function bool IsNumber()
{
    return true;
}

function JSONNumber AsNumber()
{
    return self;
}

function int AsInteger()
{
    return int(Value);
}

function float AsFloat()
{
    return float(Value);
}

function bool AsBoolean()
{
    return AsInteger() != 0;
}

function string Encode()
{
    return Value;
}

static function JSONNumber Create(string S)
{
    local JSONNumber N;

    N = new class'JSONNumber';
    N.Value = S;

    return N;
}

static function JSONNumber ICreate(int I)
{
    local JSONNumber N;

    N = new class'JSONNumber';
    N.Value = string(I);

    return N;
}

static function JSONNumber FCreate(float F)
{
    local JSONNumber N;

    N = new class'JSONNumber';
    N.Value = string(F);

    return N;
}

