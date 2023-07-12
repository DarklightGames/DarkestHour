//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// To allow for easier navigation of the construction menus, we break the the
// constructions down into groups. We allow constructions to assign themselves
// to groups to make it easier for modders to add their own constructions.
//==============================================================================

class DHConstructionGroup extends Object
    abstract;

var Material                        MenuIcon;
var localized string                GroupName;
var array<class<DHConstruction> >   ConstructionClasses;
var int                             SortOrder;

static function bool SortFunction(Object LHS, Object RHS)
{
    return class<DHConstructionGroup>(LHS).default.SortOrder > class<DHConstructionGroup>(RHS).default.SortOrder;
}
