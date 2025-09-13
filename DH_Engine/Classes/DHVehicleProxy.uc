//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleProxy extends DHActorProxy;

var class<DHMountedWeapon>   WeaponClass;

final function SetMountedWeaponClass(class<DHMountedWeapon> WeaponClass)
{
    if (WeaponClass == none)
    {
        Warn("Cannot set the stationary weapon class to none");
        return;
    }

    self.WeaponClass = WeaponClass;

    UpdateAppearance();
}

// TODO: add specific player/context errors if the player isn't crouched, moving, leaning etc.

function UpdateProxyAppearance()
{
    WeaponClass.default.VehicleClass.static.UpdateProxy(self);
}

function GetCollisionSize(Context Context, out float OutRadius, out float OutHeight)
{
    if (WeaponClass.default.VehicleClass == none)
    {
        super.GetCollisionSize(Context, OutRadius, OutHeight);
    }
    
    OutRadius = WeaponClass.default.VehicleClass.default.CollisionRadius;
    OutHeight = WeaponClass.default.VehicleClass.default.CollisionHeight;
}

function string GetMenuName()
{
    if (WeaponClass.default.VehicleClass == none)
    {
        return super.GetMenuName();
    }

    return WeaponClass.default.VehicleClass.default.VehicleNameString;
}

protected simulated function bool ShouldAlignToGround()
{
    return WeaponClass.default.bShouldAlignToGround;
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