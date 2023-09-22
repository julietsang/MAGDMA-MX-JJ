page 50121 "CRM Payment Method List"

{
    ApplicationArea = Suite;
    Caption = 'Payment Method - Dataverse';
    AdditionalSearchTerms = 'Payment Terms CDS, Payment Terms Common Data Service';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Payment methods";
    SourceTableView = sorting("Code");
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Code';
                    StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(Coupled; Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dataverse record is coupled to Business Central.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateFromCRM)
            {
                ApplicationArea = Suite;
                Caption = 'Create in Business Central';
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the entity from the coupled Dataverse  Payment Method.';
                Visible = OptionMappingEnabled;

                trigger OnAction()
                var
                    CRMPaymentMethod: Record "CRM Payment methods";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMPaymentMethod.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(CRMPaymentMethod);
                    CRMIntegrationManagement.CreateNewRecordsFromSelectedCRMOptions(CRMPaymentMethod);
                end;
            }
            action(ShowOnlyUncoupled)
            {
                ApplicationArea = Suite;
                Caption = 'Hide Coupled Payment Methods';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Do not show coupled payment Methods.';

                trigger OnAction()
                begin
                    Rec.MarkedOnly(true);
                end;
            }

            action(ShowAll)
            {
                ApplicationArea = Suite;
                Caption = 'Show Coupled Payment Method';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show coupled payment Method.';

                trigger OnAction()
                begin
                    Rec.MarkedOnly(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CRMOptionMapping: Record "CRM Option Mapping";
        CRMAccount: Record "CRM Account";
    begin
        if CRMOptionMapping.FindRecordID(Database::"CRM Account", CRMAccount.FieldNo(PaymentMethodCodeEnum), Rec."Option Id") then
            if CurrentlyMappedCRMPaymentTermOptionId = Rec."Option Id" then begin
                Coupled := 'Current';
                FirstColumnStyle := 'Strong';
                Rec.Mark(true);
            end else begin
                Coupled := 'Yes';
                FirstColumnStyle := 'Subordinate';
                Rec.Mark(false);
            end
        else begin
            Coupled := 'No';
            FirstColumnStyle := 'None';
            Rec.Mark(true);
        end;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
        Commit();
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagmeent: Codeunit "CRM Integration Management";
    begin
        OptionMappingEnabled := CRMIntegrationManagmeent.IsOptionMappingEnabled();
        LoadRecords();
    end;

    var
        CurrentlyMappedCRMPaymentTermOptionId: Integer;
        Coupled: Text;
        FirstColumnStyle: Text;
        LinesLoaded: Boolean;
        CurrentlyCoupledCountryCode: record "CRM Payment methods";
        OptionMappingEnabled: Boolean;


    procedure SetCurrentlyMappedCRMPaymentTermOptionId(OptionId: Integer)
    begin
        CurrentlyMappedCRMPaymentTermOptionId := OptionId;
    end;

    procedure SetCurrentlyCoupledCountryCode(CountryCode: Record "CRM Payment methods")
    begin
        CurrentlyCoupledCountryCode := CountryCode;
    end;

    procedure GetRec(OptionId: Integer): Record "CRM Payment methods"
    begin
        if Rec.Get(OptionId) then
            exit(Rec);
    end;

    procedure LoadRecords()
    begin
        if LinesLoaded then
            exit;

        LinesLoaded := Rec.Load();
    end;
}
