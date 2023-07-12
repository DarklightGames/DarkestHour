//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONLiteral extends JSONValue;

const NULL_STRING = "null";
const TRUE_STRING = "true";
const FALSE_STRING = "false";

var enum EJSONLiteralType
{
    JLT_Null,
    JLT_True,
    JLT_False
} Type;

static function JSONLiteral Create(string Value)
{
    local JSONLiteral L;
    local EJSONLiteralType Type;

    switch (Value)
    {
        case NULL_STRING:
            Type = JLT_Null;
            break;
        case TRUE_STRING:
            Type = JLT_True;
            break;
        case FALSE_STRING:
            Type = JLT_False;
            break;
        default:
            Warn("JSON literal could not be created from value \"" $ Value $ "\"");
            return none;
    }

    L = new class'JSONLiteral';
    L.Type = Type;

    return L;
}

static function JSONLiteral CreateNull()
{
    local JSONLiteral L;

    L = new class'JSONLiteral';
    L.Type = JLT_Null;

    return L;
}

static function JSONLiteral CreateBoolean(bool Value)
{
    if (Value)
    {
        return CreateTrue();
    }
    else
    {
        return CreateFalse();
    }
}

static function JSONLiteral CreateTrue()
{
    local JSONLiteral L;

    L = new class'JSONLiteral';
    L.Type = JLT_True;

    return L;
}

static function JSONLiteral CreateFalse()
{
    local JSONLiteral L;

    L = new class'JSONLiteral';
    L.Type = JLT_False;

    return L;
}

function bool IsNull()
{
    return Type == JLT_Null;
}

function bool IsBoolean()
{
    return Type == JLT_True || Type == JLT_False;
}

function bool AsBoolean()
{
    switch (Type)
    {
        case JLT_True:
            return true;
        default:
            return false;
    }
}

function string Encode()
{
    switch (Type)
    {
        case JLT_False:
            return FALSE_STRING;
        case JLT_True:
            return TRUE_STRING;
        default:
            return NULL_STRING;
    }
}

