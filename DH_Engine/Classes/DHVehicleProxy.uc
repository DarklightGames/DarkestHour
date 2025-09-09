//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleProxy extends DHActorProxy;

var class<DHVehicle>        VehicleClass;

final function SetVehicleClass(class<DHVehicle> VehicleClass)
{
    if (VehicleClass == none)
    {
        Warn("Cannot set the vehicle class to none");
        return;
    }

    self.VehicleClass = VehicleClass;

    UpdateAppearance();
}

// TODO: add specific player/context errors if the player isn't crouched, moving, leaning etc.

function UpdateProxyAppearance()
{
    VehicleClass.static.UpdateProxy(self);
}

function GetCollisionSize(Context Context, out float OutRadius, out float OutHeight)
{
    if (VehicleClass == none)
    {
        super.GetCollisionSize(Context, OutRadius, OutHeight);
    }
    
    OutRadius = VehicleClass.default.CollisionRadius;
    OutHeight = VehicleClass.default.CollisionHeight;
}

function string GetMenuName()
{
    if (VehicleClass == none)
    {
        return super.GetMenuName();
    }

    return VehicleClass.default.VehicleNameString;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
    bAcceptsProjectors=false
}