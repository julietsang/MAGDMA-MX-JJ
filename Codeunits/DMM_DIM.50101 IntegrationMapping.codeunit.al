Codeunit 50101 IntegrationFieldMapping
{
    trigger onrun()

    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnGetCDSTableNo', '', false, false)]
    local procedure HandleOnGetCDSTableNo(BCTableNo: Integer; var CDSTableNo: Integer; var handled: Boolean)
    begin

        if BCTableNo = Database::"Payment Method" then begin
            CDSTableNo := Database::"CRM Payment methods";
            handled := true;
        end;
        if BCTableNo = Database::"SAT Use Code" then begin
            CDSTableNo := Database::"CRM SAT Use Code";
            handled := true;
        end;
        if BCTableNo = Database::"SAT Tax Scheme" then begin
            CDSTableNo := Database::"CRM SAT Tax Scheme";
            handled := true;
        end;
        if BCTableNo = Database::"CFDI Export Code" then begin
            CDSTableNo := Database::"CRM  CFDI Export Code";
            handled := true;
        end;
        if BCTableNo = Database::"Post Code" then begin
            CDSTableNo := Database::"CDS dmm_PostCode";
            handled := true;
        end;
        if BCTableNo = Database::"Country/Region" then begin
            CDSTableNo := Database::"CDS Country/Region";
            handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables", 'OnLookupCRMTables', '', false, false)]
    local procedure HandleOnLookupCRMTables(CRMTableID: Integer; NAVTableId: Integer; SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text; var Handled: Boolean)
    begin
        if CRMTableID = Database::"CDS dmm_PostCode" then
            Handled := LookupCRMPostCode(SavedCRMId, CRMId, IntTableFilter);
        if CRMTableID = Database::"CDS Country/Region" then
            Handled := LookupCRMCountryCode(SavedCRMId, CRMId, IntTableFilter);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables", 'OnLookupCRMOption', '', true, true)]
    local procedure HandleOnLookupCRMOption(CRMTableID: Integer; NAVTableId: Integer; SavedCRMOptionId: Integer; var CRMOptionCode: Text[250]; var CRMOptionId: Integer; IntTableFilter: Text; var Handled: Boolean)
    begin
        // ResetSatusecodedMapping('SAT USE CODE');
        // ResetSattaxschemedMapping('SAT TAX SCHEME');
        if CRMTableID = Database::"CRM Payment methods" then
            Handled := LookupCRMPaymentMethod(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter);
        if CRMTableID = Database::"CRM  CFDI Export Code" then
            Handled := LookupCRMCFDIEXPORTCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter);
        if CRMTableID = Database::"CRM SAT Use Code" then
            Handled := LookupCRMSATUSECodeCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter);
        if CRMTableID = Database::"CRM SAT Tax Scheme" then
            Handled := LookupCRMSATTaxCodeCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter);

    end;


    procedure SetCouplingFlags()
    var
        CRMOptionMapping: Record "CRM Option Mapping";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        if CRMOptionMapping.FindSet() then
            repeat
                CRMIntegrationManagement.SetCoupledFlag(CRMOptionMapping, true);
            until CRMOptionMapping.Next() = 0;
    end;

    procedure LookupOptions(CRMTableID: Integer; NAVTableId: Integer; SavedCRMOptionId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]): Boolean
    var
        IntTableFilter: Text;
        Handled: Boolean;
    begin
        IntTableFilter := GetIntegrationTableFilter(CRMTableID, NAVTableId);

        OnLookupCRMOption(CRMTableID, NAVTableId, SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter, Handled);
        if Handled then
            exit(true);

        case CRMTableID of
            DATABASE::"CRM Payment methods":
                exit(LookupCRMPaymentMethod(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter));
            DATABASE::"CRM  CFDI Export Code":
                exit(LookupCRMCFDIEXPORTCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter));
            DATABASE::"CRM SAT Use Code":
                exit(LookupCRMSATUSECodeCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter));
            DATABASE::"CRM SAT Tax Scheme":
                exit(LookupCRMSATTaxCodeCode(SavedCRMOptionId, CRMOptionId, CRMOptionCode, IntTableFilter));

        end;
        exit(false);
    end;

    local procedure LookupCRMPaymentMethod(SavedCRMId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]; IntTableFilter: Text): Boolean
    var
        CRMPaymentTerms: Record "CRM Payment methods";
        OriginalCRMPaymentTerms: Record "CRM Payment methods";
        CRMPaymentTermsList: Page "CRM Payment Method List";
    begin
        if CRMOptionId <> 0 then begin
            CRMPaymentTermsList.LoadRecords();
            CRMPaymentTerms := CRMPaymentTermsList.GetRec(CRMOptionId);
            if CRMPaymentTerms."Option Id" <> 0 then
                CRMPaymentTermsList.SetRecord(CRMPaymentTerms);
            if SavedCRMId <> 0 then begin
                OriginalCRMPaymentTerms := CRMPaymentTermsList.GetRec(SavedCRMId);
                if OriginalCRMPaymentTerms."Option Id" <> 0 then
                    CRMPaymentTermsList.SetCurrentlyMappedCRMPaymentTermOptionId(SavedCRMId);
            end;
        end;
        CRMPaymentTerms.SetView(IntTableFilter);
        CRMPaymentTermsList.SetTableView(CRMPaymentTerms);
        CRMPaymentTermsList.LookupMode(true);
        Commit();
        if CRMPaymentTermsList.RunModal() = ACTION::LookupOK then begin
            CRMPaymentTermsList.GetRecord(CRMPaymentTerms);
            CRMOptionId := CRMPaymentTerms."Option Id";
            CRMOptionCode := CRMPaymentTerms."Code";
            exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMCFDIEXPORTCode(SavedCRMId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]; IntTableFilter: Text): Boolean
    var
        CRMPaymentTerms: Record "CRM  CFDI Export Code";
        OriginalCRMPaymentTerms: Record "CRM  CFDI Export Code";
        CRMPaymentTermsList: Page "CRM CFDI Export List";
    begin
        if CRMOptionId <> 0 then begin
            CRMPaymentTermsList.LoadRecords();
            CRMPaymentTerms := CRMPaymentTermsList.GetRec(CRMOptionId);
            if CRMPaymentTerms."Option Id" <> 0 then
                CRMPaymentTermsList.SetRecord(CRMPaymentTerms);
            if SavedCRMId <> 0 then begin
                OriginalCRMPaymentTerms := CRMPaymentTermsList.GetRec(SavedCRMId);
                if OriginalCRMPaymentTerms."Option Id" <> 0 then
                    CRMPaymentTermsList.SetCurrentlyMappedCRMPaymentTermOptionId(SavedCRMId);
            end;
        end;
        CRMPaymentTerms.SetView(IntTableFilter);
        CRMPaymentTermsList.SetTableView(CRMPaymentTerms);
        CRMPaymentTermsList.LookupMode(true);
        Commit();
        if CRMPaymentTermsList.RunModal() = ACTION::LookupOK then begin
            CRMPaymentTermsList.GetRecord(CRMPaymentTerms);
            CRMOptionId := CRMPaymentTerms."Option Id";
            CRMOptionCode := CRMPaymentTerms."Code";
            exit(true);
        end;
        exit(false);
    end;


    local procedure LookupCRMSATUSECodeCode(SavedCRMId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]; IntTableFilter: Text): Boolean
    var
        CRMPaymentTerms: Record "CRM SAT Use Code";
        OriginalCRMPaymentTerms: Record "CRM SAT Use Code";
        CRMPaymentTermsList: Page "CRM SAT Use Code";
    begin
        if CRMOptionId <> 0 then begin
            CRMPaymentTermsList.LoadRecords();
            CRMPaymentTerms := CRMPaymentTermsList.GetRec(CRMOptionId);
            if CRMPaymentTerms."Option Id" <> 0 then
                CRMPaymentTermsList.SetRecord(CRMPaymentTerms);
            if SavedCRMId <> 0 then begin
                OriginalCRMPaymentTerms := CRMPaymentTermsList.GetRec(SavedCRMId);
                if OriginalCRMPaymentTerms."Option Id" <> 0 then
                    CRMPaymentTermsList.SetCurrentlyMappedCRMPaymentTermOptionId(SavedCRMId);
            end;
        end;
        CRMPaymentTerms.SetView(IntTableFilter);
        CRMPaymentTermsList.SetTableView(CRMPaymentTerms);
        CRMPaymentTermsList.LookupMode(true);
        Commit();
        if CRMPaymentTermsList.RunModal() = ACTION::LookupOK then begin
            CRMPaymentTermsList.GetRecord(CRMPaymentTerms);
            CRMOptionId := CRMPaymentTerms."Option Id";
            CRMOptionCode := CRMPaymentTerms."Code";
            exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMSATTaxCodeCode(SavedCRMId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]; IntTableFilter: Text): Boolean
    var
        CRMPaymentTerms: Record "CRM SAT Tax Scheme";
        OriginalCRMPaymentTerms: Record "CRM SAT Tax Scheme";
        CRMPaymentTermsList: Page "CRM SAT Tax Scheme";
    begin
        if CRMOptionId <> 0 then begin
            CRMPaymentTermsList.LoadRecords();
            CRMPaymentTerms := CRMPaymentTermsList.GetRec(CRMOptionId);
            if CRMPaymentTerms."Option Id" <> 0 then
                CRMPaymentTermsList.SetRecord(CRMPaymentTerms);
            if SavedCRMId <> 0 then begin
                OriginalCRMPaymentTerms := CRMPaymentTermsList.GetRec(SavedCRMId);
                if OriginalCRMPaymentTerms."Option Id" <> 0 then
                    CRMPaymentTermsList.SetCurrentlyMappedCRMPaymentTermOptionId(SavedCRMId);
            end;
        end;
        CRMPaymentTerms.SetView(IntTableFilter);
        CRMPaymentTermsList.SetTableView(CRMPaymentTerms);
        CRMPaymentTermsList.LookupMode(true);
        Commit();
        if CRMPaymentTermsList.RunModal() = ACTION::LookupOK then begin
            CRMPaymentTermsList.GetRecord(CRMPaymentTerms);
            CRMOptionId := CRMPaymentTerms."Option Id";
            CRMOptionCode := CRMPaymentTerms."Code";
            exit(true);
        end;
        exit(false);
    end;


    procedure GetIntegrationTableFilter(CRMTableId: Integer; NAVTableId: Integer): Text
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        IntegrationTableMapping.SetRange(Type, IntegrationTableMapping.Type::Dataverse);
        IntegrationTableMapping.SetRange("Synch. Codeunit ID", CODEUNIT::"CRM Integration Table Synch.");
        IntegrationTableMapping.SetRange("Table ID", NAVTableId);
        IntegrationTableMapping.SetRange("Integration Table ID", CRMTableId);
        IntegrationTableMapping.SetRange("Delete After Synchronization", false);
        if IntegrationTableMapping.FindFirst() then
            exit(IntegrationTableMapping.GetIntegrationTableFilter());
        exit('');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAddEntityTableMapping', '', false, false)]
    local procedure HandleOnAddEntityTableMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary);
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        CRMSetupDefaults.AddEntityTableMapping('dmm_postcode', Database::"Post Code", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('dmm_postcode', Database::"CDS dmm_PostCode", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('dmm_countryregioncode', Database::"Country/Region", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('dmm_countryregioncode', Database::"CDS Country/Region", TempNameValueBuffer);

    end;

    local procedure LookupCRMPostCode(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var

        CRMPostCode: Record "CDS dmm_PostCode";
        OriginalCRMPostCode: Record "CDS dmm_PostCode";
        CRMPostCodeList: Page " CRM Post Code List";
    begin
        if not IsNullGuid(CRMId) then begin
            if CRMPostCode.Get(CRMId) then
                CRMPostCodeList.SetRecord(CRMPostCode);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCRMPostCode.Get(SavedCRMId) then
                    CRMPostCodeList.SetCurrentlyCoupledDataverseWorker(OriginalCRMPostCode);
        end;

        CRMPostCode.SetView(IntTableFilter);
        CRMPostCodeList.SetTableView(CRMPostCode);
        CRMPostCodeList.LookupMode(true);
        if CRMPostCodeList.RunModal = ACTION::LookupOK then begin
            CRMPostCodeList.GetRecord(CRMPostCode);
            CRMId := CRMPostCode.dmm_PostCodeId;

            exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMCountryCode(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var

        CRMCountryCode: Record "CDS Country/Region";
        OriginalCRMCountryCode: Record "CDS Country/Region";
        CRMCountryCodeList: Page " CRM Country Code List";
    begin
        if not IsNullGuid(CRMId) then begin
            if CRMCountryCode.Get(CRMId) then
                CRMCountryCodeList.SetRecord(CRMCountryCode);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCRMCountryCode.Get(SavedCRMId) then
                    // CRMCountryCodeList.SetCurrentlyCoupledDataverseWorker();
                    CRMCountryCodeList.SetCurrentlyCoupledCountryCode(OriginalCRMCountryCode);
        end;

        CRMCountryCode.SetView(IntTableFilter);
        CRMCountryCodeList.SetTableView(CRMCountryCode);
        CRMCountryCodeList.LookupMode(true);
        if CRMCountryCodeList.RunModal = ACTION::LookupOK then begin
            CRMCountryCodeList.GetRecord(CRMCountryCode);
            //CRMId := CRMCountryCode.dmm_CountryRegionCodeId;
            CRMId := CRMCountryCode.dmm_CountryRegionCodeId;
            exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCRMPaymentmethodCode(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var

        CRMCountryCode: Record "CRM Payment methods";
        OriginalCRMCountryCode: Record "CRM Payment methods";
        CRMCountryCodeList: Page "CRM Payment Method List";
    begin
        if not IsNullGuid(CRMId) then begin
            if CRMCountryCode.Get(CRMId) then
                CRMCountryCodeList.SetRecord(CRMCountryCode);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCRMCountryCode.Get(SavedCRMId) then
                    // CRMCountryCodeList.SetCurrentlyCoupledDataverseWorker();
                    CRMCountryCodeList.SetCurrentlyCoupledCountryCode(OriginalCRMCountryCode);
        end;

        CRMCountryCode.SetView(IntTableFilter);
        CRMCountryCodeList.SetTableView(CRMCountryCode);
        CRMCountryCodeList.LookupMode(true);
        if CRMCountryCodeList.RunModal = ACTION::LookupOK then begin
            CRMCountryCodeList.GetRecord(CRMCountryCode);
            CRMId := CRMCountryCode.Code;
            exit(true);
        end;
        exit(false);
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetConfiguration', '', false, false)]
    local procedure HandleOnAfterResetConfiguration(CDSConnectionSetup: Record "CDS Connection Setup")
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CRMPaymentMethod: Record "CRM Payment methods";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        FieldMappingDirection: Option;
        IsHandled: Boolean;
        OptionMappingEnabled: Boolean;
        PaymentMethod: Record "Payment Method";
        DataverseWorker: Record "CDS dmm_PostCode";
        Employee: Record "Post Code";
        CountryCode: Record "CDS Country/Region";
        CountryRegionCode: Record "Country/Region";

    begin
        ResetPaymentMethodMapping('PAYMENT METHODS');
        ResetSatusecodedMapping('SAT USE CODE');
        ResetSattaxschemedMapping('SAT TAX SCHEME');
        ResetCFDIExportMapping('CFDI EXPORT CODE');

        InsertIntegrationTableMapping(
        IntegrationTableMapping, 'POST CODE',
        Database::"Post Code", Database::"CDS dmm_PostCode",
        DataverseWorker.FieldNo(dmm_PostCodeId), DataverseWorker.FieldNo(ModifiedOn),
        '', '', true);

        InsertIntegrationFieldMapping('POST CODE', Employee.FieldNo(County),
        DataverseWorker.FieldNo(dmm_County),
        IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('POST CODE', Employee.FieldNo(City),
        DataverseWorker.FieldNo(dmm_City),
        IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('POST CODE', Employee.FieldNo(Code),
        DataverseWorker.FieldNo(dmm_PostCode),
        IntegrationFieldMapping.Direction::Bidirectional, '', true, false);

        ResetCountryCodeMapping('COUNTRY CODE');
        InsertIntegrationFieldMapping('COUNTRY CODE', CountryRegionCode.FieldNo(Code),
                CountryCode.FieldNo(dmm_CountryCode),
                IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('COUNTRY CODE', CountryRegionCode.FieldNo("County Name"),
        CountryCode.FieldNo(dmm_CountyName),
        IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('COUNTRY CODE', CountryRegionCode.FieldNo(Name),
        CountryCode.FieldNo(dmm_Name),
        IntegrationFieldMapping.Direction::Bidirectional, '', true, false);







    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetCustomerAccountMapping', '', false, false)]
    local procedure HandleOnAfterResetCustomerAccountMapping(IntegrationTableMappingName: Code[20])
    var
        CRMAccount: Record "CRM Account";
        Customer: Record Customer;
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CDSetup: Codeunit "CDS Setup Defaults";
        CRMInt: Codeunit "CRM Integration Management";
        PaymentMethod: Record "Payment Method";
        IntegrationTableMapping: Record "Integration Table Mapping";

    begin
        InsertIntegrationFieldMapping(
        'CUSTOMER',
        Customer.FieldNo("RFC No."),
        CRMAccount.FieldNo("RFC No."),
        IntegrationFieldMapping.Direction::Bidirectional,
        '', true, false);

        InsertIntegrationFieldMapping(
        'CUSTOMER',
        Customer.FieldNo("CFDI Customer Name"),
        CRMAccount.FieldNo("CFDI Customer Name"),
        IntegrationFieldMapping.Direction::Bidirectional,
        '', true, false);
        InsertIntegrationFieldMapping(
                'CUSTOMER',
                Customer.FieldNo("No."),
                CRMAccount.FieldNo("Customer No."),
                IntegrationFieldMapping.Direction::Bidirectional,
                '', true, false);



        /*  InsertIntegrationFieldMapping(
         'CUSTOMER',
         Customer.FieldNo("Tax Identification Type"),
         CRMAccount.FieldNo(TaxIdentificationTypeEnum),
         IntegrationFieldMapping.Direction::Bidirectional,
         '', true, false);*/

        InsertIntegrationFieldMapping(
          'CUSTOMER',
          Customer.FieldNo("Payment Method Code"),
        //  CRMAccount.FieldNo(PaymentMethodCodeEnum),
        CRMAccount.FieldNo(PaymentMethodCodeEnum),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', true, false);

        InsertIntegrationFieldMapping(
       'CUSTOMER',
       Customer.FieldNo("CFDI Purpose"),
       CRMAccount.FieldNo(SatusecodeCodeEnum),
       IntegrationFieldMapping.Direction::Bidirectional,
       '', true, false);

        InsertIntegrationFieldMapping(
        'CUSTOMER',
        Customer.FieldNo("SAT Tax Regime Classification"),
        CRMAccount.FieldNo(SataxschemeCodeEnum),
        IntegrationFieldMapping.Direction::Bidirectional,
        '', true, false);

        InsertIntegrationFieldMapping(
        'CUSTOMER',
        Customer.FieldNo("CFDI Export Code"),
        CRMAccount.FieldNo(CFDIExportCodeEnum),
        IntegrationFieldMapping.Direction::Bidirectional,
        '', true, false);



    end;

    procedure ResetPaymentMethodMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        PaymentMethod: Record "Payment Method";
        CRMAccount: Record "CRM Account";
        CRMpaymentmethod: Record "CRM Payment methods";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        FieldMappingDirection: Option;
        IsHandled: Boolean;
        OptionMappingEnabled: Boolean;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        IsHandled := false;
        OnBeforeResetPaymentMethodMapping(IntegrationTableMappingName, IsHandled);
        if IsHandled then
            exit;

        OptionMappingEnabled := CRMIntegrationManagement.IsOptionMappingEnabled();

        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"Payment Method", DATABASE::"CRM Account",
          CRMAccount.FieldNo(PaymentMethodCodeEnum), 0,
          '', '', OptionMappingEnabled);

        if CRMIntegrationManagement.IsOptionMappingEnabled() then
            FieldMappingDirection := IntegrationFieldMapping.Direction::ToIntegrationTable
        else
            FieldMappingDirection := IntegrationFieldMapping.Direction::FromIntegrationTable;

        // Code > "CRM Account".PaymentmethodCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          PaymentMethod.FieldNo(Code),
//CRMAccount.FieldNo(PaymentMethodCodeEnum),
CRMAccount.FieldNo(PaymentMethodCodeEnum),
          FieldMappingDirection,
          '', true, false);

    end;

    procedure ResetSatusecodedMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SatUsecode: Record "SAT Use Code";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        FieldMappingDirection: Option;
        IsHandled: Boolean;
        OptionMappingEnabled: Boolean;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        IsHandled := false;
        OnBeforeResetPaymentMethodMapping(IntegrationTableMappingName, IsHandled);
        if IsHandled then
            exit;
        OptionMappingEnabled := CRMIntegrationManagement.IsOptionMappingEnabled();
        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"SAT Use Code", DATABASE::"CRM Account",
          CRMAccount.FieldNo(SatusecodeCodeEnum), 0,
          '', '', OptionMappingEnabled);

        if CRMIntegrationManagement.IsOptionMappingEnabled() then
            FieldMappingDirection := IntegrationFieldMapping.Direction::ToIntegrationTable
        else
            FieldMappingDirection := IntegrationFieldMapping.Direction::FromIntegrationTable;

        // Code > "CRM Account".SatusecodeCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SatUsecode.FieldNo("SAT Use Code"),
          CRMAccount.FieldNo(SatusecodeCodeEnum),
          FieldMappingDirection,
          '', true, false);

    end;

    procedure ResetSattaxschemedMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SatTaxScheme: Record "SAT Tax Scheme";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        FieldMappingDirection: Option;
        IsHandled: Boolean;
        OptionMappingEnabled: Boolean;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        IsHandled := false;
        OnBeforeResetPaymentMethodMapping(IntegrationTableMappingName, IsHandled);
        if IsHandled then
            exit;

        OptionMappingEnabled := CRMIntegrationManagement.IsOptionMappingEnabled();

        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"SAT Tax Scheme", DATABASE::"CRM Account",
          CRMAccount.FieldNo(SataxschemeCodeEnum), 0,
          '', '', OptionMappingEnabled);

        if CRMIntegrationManagement.IsOptionMappingEnabled() then
            FieldMappingDirection := IntegrationFieldMapping.Direction::ToIntegrationTable
        else
            FieldMappingDirection := IntegrationFieldMapping.Direction::FromIntegrationTable;

        // Code > "CRM Account".PaymentmethodCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SatTaxScheme.FieldNo("SAT Tax Scheme"),
          CRMAccount.FieldNo(SataxschemeCodeEnum),
          FieldMappingDirection,
          '', true, false);

    end;

    procedure ResetCFDIExportMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CFDIExportCode: Record "CFDI Export Code";
        CRMAccount: Record "CRM Account";
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        FieldMappingDirection: Option;
        IsHandled: Boolean;
        OptionMappingEnabled: Boolean;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        IsHandled := false;
        OnBeforeResetPaymentMethodMapping(IntegrationTableMappingName, IsHandled);
        if IsHandled then
            exit;

        OptionMappingEnabled := CRMIntegrationManagement.IsOptionMappingEnabled();

        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"CFDI Export Code", DATABASE::"CRM Account",
          CRMAccount.FieldNo(CFDIExportCodeEnum), 0,
          '', '', OptionMappingEnabled);

        if CRMIntegrationManagement.IsOptionMappingEnabled() then
            FieldMappingDirection := IntegrationFieldMapping.Direction::ToIntegrationTable
        else
            FieldMappingDirection := IntegrationFieldMapping.Direction::FromIntegrationTable;

        // Code > "CRM Account".CFDIExportCodeEnum
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          CFDIExportCode.FieldNo(Code),
          CRMAccount.FieldNo(CFDIExportCodeEnum),
          FieldMappingDirection,
          '', true, false);

    end;

    procedure ResetCountryCodeMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CDSCountryCode: Record "CDS Country/Region";
        CountryCode: Record "Country/Region";
    begin

        InsertIntegrationTableMapping(
         IntegrationTableMapping, 'COUNTRY CODE',
         Database::"Country/Region", Database::"CDS Country/Region",
         CDSCountryCode.FieldNo(dmm_CountryRegionCodeId), CDSCountryCode.FieldNo(ModifiedOn),
         '', '', true);
        /* InsertIntegrationFieldMapping('POSTCODE', Employee.FieldNo(County),
          DataverseWorker.FieldNo(dmm_County),
          IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
         InsertIntegrationFieldMapping('POSTCODE', Employee.FieldNo(City),
         DataverseWorker.FieldNo(dmm_City),
         IntegrationFieldMapping.Direction::Bidirectional, '', true, false);*/

    end;



    [IntegrationEvent(false, false)]
    local procedure OnAfterResetCustomerAccountMapping(IntegrationTableMappingName: Code[20])
    begin
    end;


    local procedure SetIntegrationFieldMappingClearValueOnFailedSync()
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.FindLast();
        IntegrationFieldMapping."Clear Value on Failed Sync" := true;
        IntegrationFieldMapping.Modify();
    end;

    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20]; TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer; TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SynchOnlyCoupledRecords: Boolean)
    begin
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo, IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode, SynchOnlyCoupledRecords, IntegrationTableMapping.Direction::FromIntegrationTable, 'Dataverse', Codeunit::"CRM Integration Table Synch.", Codeunit::"CDS Int. Table Uncouple");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeResetPaymentMethodMapping(var IntegrationTableMappingName: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeResetCustomerAccountMapping(var IntegrationTableMappingName: Code[20]; var ShouldRecreateJobQueueEntry: Boolean; var IsHandled: Boolean)
    begin
    end;


    local procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
          ConstValue, ValidateField, ValidateIntegrationTableField);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupCRMOption(CRMTableID: Integer; NAVTableId: Integer; SavedCRMOptionId: Integer; var CRMOptionId: Integer; var CRMOptionCode: Text[250]; IntTableFilter: Text; var Handled: Boolean)
    begin
    end;

    var
        CurrentlyCoupledCRMAccount: Record "CRM Account";
        Coupled: Text;
        FirstColumnStyle: Text;


}