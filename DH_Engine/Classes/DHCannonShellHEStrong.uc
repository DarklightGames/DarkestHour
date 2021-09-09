//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHCannonShellHEStrong extends DHCannonShellHE; //for shells with heavy filler, so they can destroy obstacles

//a piece of code is copied from the satchel
var float           ObstacleDamageRadius;       // A radius that will damage Obstacles
var float           ObstacleDamageMax;

// For DH_SatchelCharge10lb10sProjectile (moved from ROSatchelChargeProjectile & necessary here due to compiler package build order):
var     PlayerReplicationInfo   SavedPRI;
var     Pawn            SavedInstigator;

// Modified to record SavedInstigator & SavedPRI
// RODemolitionChargePlacedMsg from ROSatchelChargeProjectile is omitted
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }
}

// Modified to check whether satchel blew up in a special Volume that needs to be triggered
simulated function BlowUp(vector HitLocation)
{
    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    if (Role == ROLE_Authority)
    {

        HandleObjSatchels(HitLocation);
        //HandleVehicles(HitLocation);
        HandleObstacles(HitLocation);
        //HandleConstructions(HitLocation);
        MakeNoise(1.0);
    }
}

function HandleObjSatchels(vector HitLocation)
{
    local DH_ObjSatchel SatchelObjActor;
    local Volume        V;

    foreach TouchingActors(class'Volume', V)
    {
        if (DH_ObjSatchel(V.AssociatedActor) != none)
        {
            SatchelObjActor = DH_ObjSatchel(V.AssociatedActor);

            if (SatchelObjActor.WithinArea(self))
            {
                SatchelObjActor.Trigger(self, SavedInstigator);
            }
        }

        if (V.IsA('RODemolitionVolume'))
        {
            RODemolitionVolume(V).Trigger(self, SavedInstigator);
        }
    }
}

// Allows satchels to damage obstacles when behind world geometry
function HandleObstacles(vector HitLocation)
{
    local DHObstacleInstance O;
    local float              Distance;

    foreach RadiusActors(class'DHObstacleInstance', O, ObstacleDamageRadius)
    {
        // If we cannot trace the obstacle (because of world geometry), then apply special radius damage
        if (O != none && !FastTrace(O.Location, Location))
        {
            Distance = VSize(Location - O.Location);
            O.TakeDamage(ObstacleDamageMax * (Distance / ObstacleDamageRadius), SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
        }
    }
}

defaultproperties
{
    ObstacleDamageRadius=500
    ObstacleDamageMax=1400

}
