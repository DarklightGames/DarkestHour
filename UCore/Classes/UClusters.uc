//==============================================================================
// Darklight Games (c) 2008-2019
//==============================================================================

class UClusters extends Object;

const NOISE = -1;
const UNCLASSIFIED = 0;

struct DataPoint
{
    var Object Item;
    var vector Location;
    var int    ClId;
};

var array<DataPoint> Data;

delegate float GetItemPriority(Object O);

function Clear() { Data.Length = 0; }

function ResetClusterIDs()
{
    local int i;

    for (i = 0; i < Data.Length; ++i)
    {
        Data[i].ClId = 0;
    }
}

function UHeap ToHeap()
{
    local UHeap GroupedData;
    local array<UHeap> Clusters;
    local array<Object> Noise;
    local int i, ClusterIndex;

    // Group clustered items into heaps
    for (i = 0; i < Data.Length; ++i)
    {
        if (Data[i].ClId == 0)
        {
            Warn("Found an unclassified item");
            continue;
        }

        if (Data[i].ClId > 0)
        {
            ClusterIndex = Data[i].ClId - 1;

            if (ClusterIndex > Clusters.Length)
            {
                Warn("Index overflow");
                continue;
            }

            if (ClusterIndex == Clusters.Length)
            {
                Clusters[Clusters.Length] = new class'UHeap';
            }

            Clusters[ClusterIndex].Insert(Data[i].Item, GetItemPriority(Data[i].Item));

            continue;
        }

        Noise[Noise.Length] = Data[i].Item;
    }

    GroupedData = new class'UHeap';

    // Add clusters
    for (i = 0; i < Clusters.Length; ++i)
    {
        // TODO: Instead of the size, the summary value of contained items should be
        // used to determine the top cluster.
        GroupedData.Insert(Clusters[i], Clusters[i].GetLength(), i + 1);
    }

    // Add noise
    for (i = 0; i < Noise.Length; ++i)
    {
        GroupedData.Insert(Noise[i], GetItemPriority(Noise[i]), -1);
    }

    return GroupedData;
}

// https://www.aaai.org/Papers/KDD/1996/KDD96-037.pdf
function DBSCAN(float Eps, int MinPts)
{
    local int i, ClusterId;

    ClusterId = 1;

    for (i = 0; i < Data.Length; ++i)
    {
        if (Data[i].ClId == UNCLASSIFIED && ExpandCluster(i, ClusterId, Eps, MinPts))
        {
            ++ClusterId;
        }
    }
}

private function bool ExpandCluster(int Point, int ClId, float Eps, int MinPts)
{
    local int i;
    local array<int> Seeds, SeedNeighbors;

    Seeds = RegionQuery(Point, Eps);

    if (Seeds.Length < MinPts)
    {
        // Noise
        Data[Point].ClId = NOISE;
        return false;
    }

    // The point is a core point
    Data[Point].ClId = ClId;
    ChangeClIds(Seeds, ClId);

    while (Seeds.Length > 0)
    {
        SeedNeighbors = RegionQuery(Seeds[0], Eps);

        if (SeedNeighbors.Length >= MinPts)
        {
            for (i = 0; i < SeedNeighbors.Length; ++i)
            {
                // The point is either unclassified or noise
                if (Data[SeedNeighbors[i]].ClId < 1)
                {
                    if (Data[SeedNeighbors[i]].ClId == UNCLASSIFIED)
                    {
                        Seeds[Seeds.Length] = i;
                    }

                    Data[SeedNeighbors[i]].ClId = ClId;
                }
            }
        }

        Seeds.Remove(0, 1);
    }

    return true;
}

private function array<int> RegionQuery(int Point, float Eps)
{
    local int i;
    local array<int> Points;

    for (i = 0; i < Data.Length; ++i)
    {
        if (i != Point && VSize(Data[i].Location - Data[Point].Location) <= Eps)
        {
            Points[Points.Length] = i;
        }
    }

    return Points;
}

private function ChangeClIds(array<int> Points, int ClId)
{
    local int i;

    for (i = 0; i < Points.Length; ++i)
    {
        Data[Points[i]].ClId = ClId;
    }
}

// Depending on whatever has the highest priority, this function will either
// output a regression line for large clusters (line size is larger than
// MinThreshold), or a single location (PointA == PointB) for solitary actors
// and tiny clusters.
//
// False is returned if the dataset does not contain any actors.
//
// TODO: Clusters that containt an abnormaly valuable item should
//       probably be collapsed to a single point.
static function bool GetPriorityVector(UHeap Clusters, out vector PointA, out vector PointB, optional float MinThreshold)
{
    local UHeap Heap;
    local Actor Actor;
    local Object Item;
    local array<vector> Locations;
    local int i;

    if (Clusters == none)
    {
        return false;
    }

    // The top item is a cluster
    if (Clusters.RootIsHeap(Heap))
    {
        for (i = 0; i < Heap.Data.Length; ++i)
        {
            if (Heap.Data[i].Item != none)
            {
                Actor = Actor(Heap.Data[i].Item);

                if (Actor != none)
                {
                    Locations[Locations.Length] = Actor.Location;
                }
            }
        }

        switch (Locations.Length)
        {
            case 0:
                return false;
            case 1:
                PointA = Locations[0];
                PointB = PointA;
                break;
            default:
                class'UVector'.static.LinearRegression(Locations, PointA, PointB);
                break;
        }

        if (MinThreshold > 0.0 && VSize(PointA - PointB) < MinThreshold)
        {
            PointA = (PointA + PointB) * 0.5;
            PointB = PointA;
        }

        return true;
    }

    // The top item is noise
    Item = Clusters.Peek();

    if (Item != none)
    {
        Actor = Actor(Item);

        if (Actor == none)
        {
            return false;
        }

        PointA = Actor.Location;
        PointB = PointA;

        Actor = none;

        return true;
    }
}

// Returns a list of actors in the largest cluster
function array<Actor> GetPriorityActors()
{
    local UHeap Queue;
    local array<Actor> A;

    Queue = ToHeap();
    A = Queue.RootToActors();
    Queue.ClearNested();

    return A;
}


static function UClusters CreateFromActors(array<Actor> A, Functor_float_Object PriorityFunction, float Epsilon, int MinPoints)
{
    local UClusters Clusters;
    local int i;

    if (PriorityFunction == none || A.Length <= 0)
    {
        return none;
    }

    Clusters = new class'UClusters';

    for (i = 0; i < A.Length; ++i)
    {
        Clusters.Data[Clusters.Data.Length].Item = A[i];
        Clusters.Data[Clusters.Data.Length].Location = A[i].Location;
    }

    Clusters.GetItemPriority = PriorityFunction.DelegateFunction;
    Clusters.DBSCAN(Epsilon, MinPoints);

    return Clusters;
}

// DEBUG

function DebugLog()
{
    local int i;
    local string ClusterId;

    Log("CLUSTER DATA:");

    for (i = 0; i < Data.Length; ++i)
    {
        switch (Data[i].ClId)
        {
            case UNCLASSIFIED:
                ClusterId = "UNPROCESSED";
                break;
            case NOISE:
                ClusterId = "Noise";
                break;
            default:
                ClusterId = "Cluster:" @ Data[i].ClId;
        }

        Log(i $ ":" @ string(Data[i].Item.Class) @ ">" @ ClusterId @ "> Loc:" @ string(Data[i].Location));
    }
}
