//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObjectiveTreeNode extends Object;

var DHObjectiveTreeNode         Parent;
var DHObjective                 Objective;
var array<DHObjectiveTreeNode>  Children;

function bool HasParent()
{
    return Parent != none;
}

function bool HasChildren()
{
    return Children.Length > 0;
}
