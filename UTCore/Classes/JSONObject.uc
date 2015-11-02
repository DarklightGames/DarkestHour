//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class JSONObject extends Object;

enum EJSONObjectType
{
    JOT_Primitive,
    JOT_Object,
    JOT_Array,
    JOT_String,
};

struct JSONData
{
    var float Number;
    var string String;
    var bool Boolean;
    var array<JSONObject> Array;
    //var ObjectDictionary Object;
};

var EJSONObjectType Type;
var JSONData        Data;
