//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
