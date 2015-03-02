//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_VehicleWeaponCollisionMeshActor extends Actor;

/**
Matt, Nov 2014: this actor is a way of getting a collision static mesh to work on a VehicleWeapon (generally a turret, but maybe an exposed MG or a gun shield)

You can see in the RO vehicle static mesh packages that turret col meshes were made, but are not used (DH also has 1 or 2).
Instead turrets only have simple box collision, which give only crude hit detection. TWI must have hit a problem, so why weren't the turret col meshes used?
The answer is that in UT2004 skeletal meshes, a col mesh can't be attached to a bone, only to the skeletal mesh origin.
That works fine for a vehicle hull, but a VehicleWeapon actor always faces directly forwards, relative to the hull.
The actual VW actor doesn't rotate relatively, only it's yaw bone rotates, which makes the weapon rotate visibly - but the actual actor itself isn't rotating.
So the VW col mesh, which is attached to the origin, always stays facing forwards, relative to the hull.
As soon as the weapon rotates, the col mesh is no longer aligned with the weapon & hit detection is completely screwed up.
The 1 vehicle that does use a turret col mesh is the tiger - to see the screwed up result, in single player type "show collision" in console, rotate turret & take a look !!

This is a workaround that solves the problem. This is the sequence of events, which is actually very simple:
1. If a col mesh actor class has been specified in the WV class, the VW spawns the col mesh actor in PostBeginPlay, with the VW as col mesh's owner.
2. VW attaches col mesh actor to VW's YawBone - col mesh will now rotate with the VW.
3. VW removes all of its own collision, so no hit will ever be detected on the VW itself.
4. Col mesh actor has the same collision properties as the VW, so projectiles will hit the col mesh & trigger ProcessTouch.
5. All projectile ProcessTouch functions begin by checking if the hit actor is a col mesh actor.
6. If projectile has hit a col mesh actor, it simple switches the hit actor to be the col mesh's owner, which is the actual VW.
7. Projectile ProcessTouch then simply continues as if it hit the actual VW, with the usual hit & penetration calcs & results.
8. For other collision, e.g. a player walking on a turret, the col mesh actor also handles that as if the colliding actor collided with the actual VW.

The only complication is the need for the col mesh actor to have a skeletal mesh to attach the col static mesh on to.
But it can be a generic mesh that just contains 1 bone & no geometry, only collision boxes & the attached col mesh.

To set up a VW col mesh actor the process is:
1. Import a generic 1 bone mesh into the WV's animation file & name it something like MyVehicle_TurretCollision.
2. Copy mesh properties of the actual VW mesh & paste onto collision skeletal mesh, so new mesh has same collision boxes (enable view collision in editor to see this).
3. Assign the col static mesh to the new collision skeletal mesh.
4. Create new col mesh actor class that extends DH_VehicleWeaponCollisionMeshActor, named something like DH_MyVehicleTurretCollisionMesh.
5. In col mesh actor class just add in default props: Mesh = SkeletalMesh'DH_MyVehicle_anm_WIP.MyVehicle_TurretCollision'.
6. in WV class just add in default props: CollisionMeshActorClass = class'DH_MyVehicleTurretCollisionMesh'

When modelling a new VW col mesh, e.g. a tank turret:
- Keep the mesh as simple as possible with as few triangles as possible - just model the main shape of the turret, where a shell may potentially hit & destroy.
- Do not use the actual turret model as a col mesh, as it's unnecessarily detailed for collision calcs, which should always be a simple as possible.
- Do not include a cannon barrel as if it's hit by a shell it may well cause the whole vehicle to explode.
- A col static mesh only 'sculpts' collision primitives (boxes or spheres), so to be effective it must exist within a col primitive.
- So parts of a col mesh outside of col primitives have no effect, and parts of col primitive outside of col mesh have no effect.
- So some mesh geometry is necessary where there is a col box for a player character like a commander, otherwise he can't be hit.
- Player geometry can either be modelled to roughly fit player (which effectively makes player's HitPoints in VW class redundant), 
  or can just add a simple box shape to match player's col box (which then still relies on player's HitPoints for accurate hit detection).
*/

// Modified to copy VehicleWeapon's collision size & to turn this static mesh invisible (using alpha texture)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (VehicleWeapon(Owner) != none)
    {
        SetCollisionSize(Owner.CollisionRadius, Owner.CollisionHeight);
        Skins[0] = texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha';
    }
    else
    {
        Warn("DH_VehicleWeaponCollisionMeshActor somehow spawned without owning VehicleWeapon: destroying" @ Tag);
        Destroy();
    }
}

// Col mesh actor should never take damage, so just in case we'll call TakeDamage on the owning VehicleWeapon, which would have otherwise have received the call
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Owner.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
    DrawType=DT_Mesh
    bCollideActors=true
    bBlockActors=true
    bIgnoreEncroachers=true
    RemoteRole=ROLE_None
}
