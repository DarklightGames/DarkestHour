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

    //Vehicle registry for abbrivaiated names, this is to enable a person to spawn a vehicle without looking up the class name
    //Much like the weapon registry
    //TEMPLATE
    //Records()=(VehicleNames=(""),Variants=((ClassName="DH_Vehicles."),(ClassName="DH_Vehicles.",VariantName="")))

    //Watch for spaces between commas when defining variant type as this will throw an error

    //wheeled vehicles (soft skin/lightly armored)
    //Soviet
    Records(0)=(VehicleNames=("ba64","clowncar"),Variants=((ClassName="DH_Vehicles.DH_BA64ArmoredCar"),(ClassName="DH_Vehicles.DH_BA64ArmoredCar_Snow",VariantName="snow")))
    Records(1)=(VehicleNames=("gaz67","gaz"),Variants=((ClassName="DH_Vehicles.DH_GAZ67Vehicle")))
    Records(2)=(VehicleNames=("zis5","ZiS5transport","zistransport"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckTransport")))
    Records(3)=(VehicleNames=("zislogi","zis5logi","ZiS5logi"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckSupport")))
    //American/British
    Records(4)=(VehicleNames=("gmc"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckTransport"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="haloween"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="spooky")))
    Records(5)=(VehicleNames=("gmclogi","gmcsupply"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckSupport"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Halloween",VariantName="haloween")))
    Records(6)=(VehicleNames=("jeep","willysjeep"),Variants=((ClassName="DH_Vehicles.DH_WillysJeep"),(ClassName="DH_Vehicles.DH_WillysJeep_SovietRoof",VariantName="sovietroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_WillysJeep_SnowRoof",VariantName="snowroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_WillysJeep_Roof",VariantName="roof"),(ClassName="DH_Vehicles.DH_WillysJeep_ItalyRoof",VariantName="italyroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_WillysJeep_DesertRoof",VariantName="desertroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Desert",VariantName="desert"),(ClassName="DH_Vehicles.DH_WillysJeep_AirborneRoof",VariantName="airborneroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Airborne",VariantName="airborne")))
    //German
    Records(7)=(VehicleNames=("kubel","kubelwagen"),Variants=((ClassName="DH_Vehicles.DH_KubelwagenCar_WH.uc"),(ClassName="DH_Vehicles.DH_KubelwagenCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_KubelwagenCar_SS",VariantName="SS"),(ClassName="DH_Vehicles.DH_KubelwagenCarTwo_SS",VariantName="SStwo")))
    Records(8)=(VehicleNames=("opel"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzTransport"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_NoTarp",VariantName="notarp")))
    Records(9)=(VehicleNames=("opellogi"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzSupport"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_NoTarp",VariantName="notarp")))
    
    //--+--

    //Armored cars and halftracks (heavily Armored)
    //Soviet (there are none currently)

    //American/british
    Records(10)=(VehicleNames=("greyhound","m8"),Variants=((ClassName="DH_Vehicles.DH_GreyhoundArmoredCar"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_British",VariantName="british"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_Snow",VariantName="snow")))
    Records(11)=(VehicleNames=("m3halftrack","americanhalftrack","americanHT"),Variants=((ClassName="DH_Vehicles.DH_M3A1HalftrackTransport"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet_Snow",VariantName="sovietsnow"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Snow",VariantName="snow")))
    //German
    Records(12)=(VehicleNames=("sdkfz105","sdk105","flakwagen"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz105Transport"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Camo",VariantName="camo"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored",VariantName="armored"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Snow",VariantName="armoredsnow"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Camo",VariantName="armoredcamo")))
    Records(13)=(VehicleNames=("sdkfz251","germanhalftrack","germanht"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz251Transport"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowOne",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowWhiteWash",VariantName="snowthree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoThree",VariantName="camothree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoFour",VariantName="camofour"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="allies"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="captured")))
    Records(14)=(VehicleNames=("sdkfz251/22","sdk251/22","pakwagen"),Variants=((ClassName="DH_Vehicles.DH_SdKfz251_22Transport")))
    Records(15)=(VehicleNames=("sdkfz251/9d","sdkfz251/9","sdk251/9","stummel"),Variants=((ClassName="DH_Vehicles.DH_SdKfz2519DTransport"),(ClassName="DH_Vehicles.DH_SdKfz2519DTransport_Snow",VariantName="snow")))





}

