//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// Implementation is based on minimal-json (github.com/ralfstx/minimal-json)
//==============================================================================

class JSONTest extends Object
    abstract;

static function Test()
{
    local JSONValue V;
    local JSONParser P;

    P = new class'JSONParser';
    V = P.Parse("{\"cmon\":\"test\",\"list\":[0,\"1\",2,3]}");
    Log(V.Encode());
}
