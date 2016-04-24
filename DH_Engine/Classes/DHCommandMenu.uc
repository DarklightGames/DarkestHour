//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCommandMenu extends Object
    abstract;

struct Option
{
    var localized string Text;
    var Material Material;
};

var array<Option> Options;

var DHCommandMenu NextMenu;
var DHCommandMenu PreviousMenu;

function bool OnSelect(int Index);
