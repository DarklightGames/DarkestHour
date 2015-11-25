//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONLiteral extends JSONValue;

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
        case "null":
            Type = JLT_Null;
            break;
        case "true":
            Type = JLT_True;
            break;
        case "false":
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