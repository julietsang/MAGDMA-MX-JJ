table 50132 "CDS Country/Region"
{
    ExternalName = 'dmm_countryregioncode';
    TableType = CDS;
    Description = '';

    fields
    {
        field(1; dmm_CountryRegionCodeId; GUID)
        {
            ExternalName = 'dmm_countryregioncodeid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'Identificador único de instancias de entidad';
            Caption = 'Country Code';
        }
        field(2; CreatedOn; Datetime)
        {
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'Fecha y hora de creación del registro.';
            Caption = 'Fecha de creación';
        }
        field(4; ModifiedOn; Datetime)
        {
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
            ExternalAccess = Read;
            Description = 'Fecha y hora en que se modificó el registro.';
            Caption = 'Fecha de modificación';
        }
        field(18; statecode; Option)
        {
            ExternalName = 'statecode';
            ExternalType = 'State';
            ExternalAccess = Modify;
            Description = 'Estado del Post Code';
            Caption = 'Estado';
            InitValue = " ";
            OptionMembers = " ",Activo,Inactivo;
            OptionOrdinalValues = -1, 0, 1;
        }
        field(20; statuscode; Option)
        {
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            Description = 'Razón para el estado del Código Postal';
            Caption = 'Razón para el estado';
            InitValue = " ";
            OptionMembers = " ",Activo,Inactivo;
            OptionOrdinalValues = -1, 1, 2;
        }
        field(22; VersionNumber; BigInteger)
        {
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
            ExternalAccess = Read;
            Description = 'Número de versión';
            Caption = 'Número de versión';
        }
        field(23; ImportSequenceNumber; Integer)
        {
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
            ExternalAccess = Insert;
            Description = 'Número de secuencia de la importación que creó este registro.';
            Caption = 'Número de secuencia de importación';
        }
        field(24; OverriddenCreatedOn; Date)
        {
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
            ExternalAccess = Insert;
            Description = 'Fecha y hora en que se migró el registro.';
            Caption = 'Fecha de creación del registro';
        }
        field(25; TimeZoneRuleVersionNumber; Integer)
        {
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            Description = 'Solo para uso interno.';
            Caption = 'Número de versión de regla de zona horaria';
        }
        field(26; UTCConversionTimeZoneCode; Integer)
        {
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            Description = 'Código de la zona horaria que estaba en uso cuando se creó el registro.';
            Caption = 'Código de zona horaria de conversión UTC';
        }
        field(27; dmm_CountryCode; Text[100])
        {
            ExternalName = 'dmm_countrycode';
            ExternalType = 'String';
            Description = '';
            Caption = 'Country/Region Code';
        }
        field(28; dmm_AddressFormat; Text[100])
        {
            ExternalName = 'dmm_addressformat';
            ExternalType = 'String';
            Description = '';
            Caption = 'Address Format';
        }
        field(31; dmm_ContactAddressFormat; Text[100])
        {
            ExternalName = 'dmm_contactaddressformat';
            ExternalType = 'String';
            Description = '';
            Caption = 'ContactAddressFormat';
        }
        field(32; dmm_CountyName; Text[100])
        {
            ExternalName = 'dmm_countyname';
            ExternalType = 'String';
            Description = '';
            Caption = 'County Name';
        }
        field(33; dmm_IsoCode; Text[100])
        {
            ExternalName = 'dmm_isocode';
            ExternalType = 'String';
            Description = '';
            Caption = 'Iso Code';
        }
        field(34; dmm_IsoNumericCode; Text[100])
        {
            ExternalName = 'dmm_isonumericcode';
            ExternalType = 'String';
            Description = '';
            Caption = 'Iso Numeric Code';
        }
        field(35; dmm_Name; Text[100])
        {
            ExternalName = 'dmm_name';
            ExternalType = 'String';
            Description = '';
            Caption = 'Name';
        }
        field(36; dmm_VatScheme; Text[100])
        {
            ExternalName = 'dmm_vatscheme';
            ExternalType = 'String';
            Description = '';
            Caption = 'Vat Scheme';
        }
        field(37; dmm_SatCountryCode; Guid)
        {
            Caption = 'Sat Country Code';
            Description = 'Choose the Sat country code';
            ExternalName = 'dmm_satcountrycode';
            ExternalType = 'Lookup';
            TableRelation = "SAT Country Code"."SAT Country Code";
        }

    }
    keys
    {
        key(PK; dmm_CountryRegionCodeId)
        {
            Clustered = true;
        }
        key(Name; dmm_CountryCode)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; dmm_CountryCode)
        {
        }
    }
}