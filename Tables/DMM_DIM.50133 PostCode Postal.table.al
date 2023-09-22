table 50133 "CDS dmm_PostCode"
{
    ExternalName = 'dmm_postcode';
    TableType = CDS;
    Description = '';

    fields
    {
        field(1; dmm_PostCodeId; GUID)
        {
            ExternalName = 'dmm_postcodeid';
            ExternalType = 'Uniqueidentifier';
            ExternalAccess = Insert;
            Description = 'Identificador único de instancias de entidad';
            Caption = 'Post Code';
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
        field(27; dmm_PostCode; Text[100])
        {
            ExternalName = 'dmm_postcode';
            ExternalType = 'String';
            Description = '';
            Caption = 'Post Code 2';
        }
        field(28; dmm_City; Text[100])
        {
            ExternalName = 'dmm_city';
            ExternalType = 'String';
            Description = '';
            Caption = 'City';
        }
        field(31; dmm_County; Text[100])
        {
            ExternalName = 'dmm_county';
            ExternalType = 'String';
            Description = '';
            Caption = 'County';
        }
        field(32; "Coupled to CRM"; Boolean)
        {
            Caption = 'Coupled to CRM';
            Description = 'Coupled to CRM';
        }
    }
    keys
    {
        key(PK; dmm_PostCodeId)
        {
            Clustered = true;
        }
        key(Name; dmm_PostCode)
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; dmm_PostCode)
        {
        }
    }
}