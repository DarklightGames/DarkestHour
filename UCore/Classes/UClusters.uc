//==============================================================================
// Darklight Games (c) 2008-2019
//==============================================================================

class UClusters extends Object;

struct DataPoint
{
    var Object Item;
    var vector Location;
    var int    ClId; // -1 -- noise,
                     //  0 -- unclassified
                     // >0 -- cluster id
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

// Return the highest priority item in the top cluster
// TODO: !
function Object FindHighestPriorityItem()
{
    local UHeap GroupedData;
    local array<UHeap> Clusters;
    local array<Object> Noise;
    local Object O;
    local int i, ClusterIndex, ClusterCount;

    // Group clustered items into heaps
    for (i = 0; i < Data.Length; ++i)
    {
        if (Data[i].ClId == 0)
        {
            Warn("Found an unclassified item");
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
        GroupedData.Insert(Clusters[i].Peek(), Clusters[i].GetLength());
    }

    // Add noise
    for (i = 0; i < Noise.Length; ++i)
    {
        GroupedData.Insert(Noise[i], GetItemPriority(Noise[i]));
    }

    // REMOVE: DEBUG STUFF
    // GroupedData.DebugLog();

    O = GroupedData.Peek();

    // Clean up everything just in case
    for (i = 0; i < Clusters.Length; ++i)
    {
        Clusters[i].Clear();
    }

    GroupedData.Clear();

    return O;
}

// https://www.aaai.org/Papers/KDD/1996/KDD96-037.pdf
function DBSCAN(float Eps, int MinPts)
{
    local int i, Point, ClusterId;

    ClusterId = 1;

    for (i = 0; i < Data.Length; ++i)
    {
        if (Data[i].ClId == 0 && ExpandCluster(i, ClusterId, Eps, MinPts))
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
        Data[Point].ClId = -1;
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
                    if (Data[SeedNeighbors[i]].ClId == 0)
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
            case 0:
                ClusterId = "UNPROCESSED";
                break;
            case -1:
                ClusterId = "Noise";
                break;
            default:
                ClusterId = "Cluster:" @ Data[i].ClId;
        }

        Log(i $ ":" @ string(Data[i].Item.Class) @ ">" @ ClusterId @ "> Loc:" @ string(Data[i].Location));
    }
}
