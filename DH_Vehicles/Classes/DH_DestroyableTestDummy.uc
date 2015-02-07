//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

// Matt: originally extended RODestroyableStaticMeshBase, but lots of classes look for a RODestroyableStaticMesh, which is a subclass of RODSMBase & so won't be found
// Makes no difference in function, as RODSM is just an empty class that extends RODSMBase, so does exactly the same thing
class DH_DestroyableTestDummy extends RODestroyableStaticMesh;

var()   name    SensorName;

auto state Working
{
    function TakeDamage(int Damage, Pawn InstigatedBy, vector hitlocation,  vector momentum, class<DamageType> damageType, optional int HitIndex)
    {
        if (!ShouldTakeDamage(damageType))
        {
            return;
        }

        if (InstigatedBy != none)
        {
            MakeNoise(1.0);
        }

        Health -= Damage;
        Level.Game.Broadcast(self, "Dummy:" @ SensorName $ ", DamageTaken:" @ Damage @ "points");
        Log("Dummy:" @ SensorName $ ", DamageTaken:" @ Damage @ "points");

        if (Health <= 0)
        {
            TriggerEvent(DestroyedEvent, self, InstigatedBy);
            BroadcastCriticalMessage(InstigatedBy);
            BreakApart(HitLocation, Momentum);
        }
    }
}

defaultproperties
{
    SensorName="Shurek"
}
