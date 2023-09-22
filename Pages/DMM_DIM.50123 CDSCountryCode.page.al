#pragma implicitwith disable
page 50123 " CRM Country Code List"
{
    PageType = List;
    SourceTable = "CDS Country/Region";
    Editable = false;
    ApplicationArea = suite;
    UsageCategory = Lists;
    Caption = 'Country- Dataverse';
    AdditionalSearchTerms = 'Country CDS, Country Common Data Service';

    SourceTableView = SORTING(dmm_CountryCode);


    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(dmm_CountyName; Rec.dmm_CountyName)
                {
                    ApplicationArea = Suite;
                    Caption = 'County';
                    ToolTip = 'Specifies if the Dataverse record is coupled to Business Central.';
                }
                field(dmm_Name; Rec.dmm_Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }

                field(dmm_CountryCode; Rec.dmm_CountryCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Country Code';
                    //  StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_AddressFormat; Rec.dmm_AddressFormat)
                {
                    ApplicationArea = Suite;
                    Caption = 'Address Format';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_ContactAddressFormat; Rec.dmm_ContactAddressFormat)
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact Address Format';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_IsoCode; Rec.dmm_IsoCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'ISO Code';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_IsoNumericCode; Rec.dmm_IsoNumericCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Iso Numeric Code';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_SatCountryCode; Rec.dmm_SatCountryCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sat Country Code';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_VatScheme; Rec.dmm_VatScheme)
                {
                    ApplicationArea = Suite;
                    Caption = 'Vat Scheme';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }



                /*field("Coupled to CRM"; "Coupled to CRM")
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dataverse record is coupled to Business Central.';
                }*/

                // add fields to display on the page
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(CreateFromDataverse)
            {
                ApplicationArea = All;
                Caption = 'Create in Business Central';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the table from the coupled Microsoft Dataverse worker.';

                trigger OnAction()
                var
                    CountryCode: Record "CDS Country/Region";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(CountryCode);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(CountryCode);
                end;
            }
        }
    }

    var
        CurrentlyCoupledCountryCode: record "CDS Country/Region";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;



    procedure SetCurrentlyCoupledCountryCode(CountryCode: Record "CDS Country/Region")
    begin
        CurrentlyCoupledCountryCode := CountryCode;
    end;
}
#pragma implicitwith restore
