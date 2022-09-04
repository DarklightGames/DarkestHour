//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHVehicleRegistry extends Object
    abstract;

struct SVehicleRecordVariant
{
    var string VariantName;
    var string ClassName;
};

struct SVehicleRecord
{
    var array<string> VehicleNames;
    var array<SVehicleRecordVariant> Variants;
};

var array<SVehicleRecord> Records;

static function string GetClassNameFromVehicleName(string VehicleName, optional string VariantName)
{
    local int i, j, k;

    VehicleName = Caps(VehicleName);

    for (i = 0; i < default.Records.Length; ++i)
    {
        for (j = 0; j < default.Records[i].VehicleNames.Length; ++j)
        {
            if (StrCmp(VehicleName, default.Records[i].VehicleNames[j]) == 0)
            {
                for (k = 0; k < default.Records[i].Variants.Length; ++k)
                {
                    if (StrCmp(default.Records[i].Variants[k].VariantName, VariantName) == 0)
                    {
                        return default.Records[i].Variants[k].ClassName;
                    }
                }

                return "";
            }
        }
    }

    return "";
}

static function DumpToLog(PlayerController PC)
{
    local int i, j;
    local array<string> VariantNames;
    local string LogLine;

    if (PC == none)
    {
        return;
    }

    for (i = 0; i < default.Records.Length; ++i)
    {
        VariantNames.Length = 0;
        LogLine = "";

        for (j = 0; j < default.Records[i].Variants.Length; ++j)
        {
            if (default.Records[i].Variants[j].VariantName == "")
            {
                continue;
            }

            VariantNames[VariantNames.Length] = default.Records[i].Variants[j].VariantName;
        }

        LogLine = class'UString'.static.Join(", ", default.Records[i].VehicleNames);

        if (VariantNames.Length > 0)
        {
            LogLine @= "-" @ "(" $ class'UString'.static.Join(", ", VariantNames) $ ")";
        }

        PC.Log(LogLine);
    }
}

defaultproperties
{

    //wheeled vehicles
    Records(0)=(VehicleNames=("ba64", "clowncar"),Variants=((ClassName="DH_Vehicles.DH_BA64ArmoredCar"),(ClassName="DH_Vehicles.DH_BA64ArmoredCar_Snow",VariantName="snow")))
    Records(1)=(VehicleNames=("gaz67", "gaz"),Variants=((ClassName="DH_Vehicles.DH_GAZ67Vehicle")))
    Records(2)=(VehicleNames=("unicarrier"),Variants=((ClassName="DH_Vehicles.DH_BrenCarrierTransport"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Africa",VariantName="africa"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_GermanCarrierTransport",VariantName="german"),(ClassName="DH_Vehicles.DH_GermanCarrierTransport_Africa",VariantName="germanafrica")))
    Records(3)=(VehicleNames=("bt7"),Variants=((ClassName="DH_Vehicles.DH_BT7Tank"),(ClassName="DH_Vehicles.DH_BT7Tank_Snow",VariantName="snow")))
    Records(4)=(VehicleNames=("churchill"),Variants=((ClassName="DH_Vehicles.DH_ChurchillMKVIITank")))
    Records(5)=(VehicleNames=("cromwell"),Variants=((ClassName="DH_Vehicles.DH_Cromwell6PdrTank"),(ClassName="DH_Vehicles.DH_Cromwell6PdrTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Cromwell95mmTank",VariantName="95mm"),(ClassName="DH_Vehicles.DH_Cromwell95mmTank_Snow",VariantName="95mmsnow")))
    Records(6)=(VehicleNames=("gaz67", "gaz"),Variants=((ClassName="DH_Vehicles.DH_GAZ67Vehicle")))
    Records(7)=(VehicleNames=("gmc"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckTransport"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Snow",VariantName="snow")))
    Records(8)=(VehicleNames=("greyhound", "m8"),Variants=((ClassName="DH_Vehicles.DH_GreyhoundArmoredCar"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_British",VariantName="british"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_Snow",VariantName="snow")))
}

