#pragma implicitwith disable
page 50120 "CRM SAT Tax Scheme"


{
    ApplicationArea = Suite;
    Caption = 'SAT Tax Scheme - Dataverse';
    AdditionalSearchTerms = 'SAT Tax Regime Classification';
    Editable = false;
    PageType = List;
    SourceTable = "CRM SAT Tax Scheme";
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
                ToolTip = 'Generate the entity from the coupled Dataverse SAT Tax Scheme  Code.';
                Visible = OptionMappingEnabled;

                trigger OnAction()
                var
                    CRMPaySATTaxSchemeCode: Record "CRM SAT Tax Scheme";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMPaySATTaxSchemeCode.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(CRMPaySATTaxSchemeCode);
                    CRMIntegrationManagement.CreateNewRecordsFromSelectedCRMOptions(CRMPaySATTaxSchemeCode);
                end;
            }
            action(ShowOnlyUncoupled)
            {
                ApplicationArea = Suite;
                Caption = 'Hide Coupled SAT Tax Scheme Code';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Do not show coupled SAT Tax scheme Code.';

                trigger OnAction()
                begin
                    Rec.MarkedOnly(true);
                end;
            }
            action(ShowAll)
            {
                ApplicationArea = Suite;
                Caption = 'Show Coupled SAT Tax scheme Code';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show coupled SAT Tax Scheme Code.';

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
        if CRMOptionMapping.FindRecordID(Database::"CRM Account", CRMAccount.FieldNo(SataxschemeCodeEnum), Rec."Option Id") then
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
        OptionMappingEnabled: Boolean;

    procedure SetCurrentlyMappedCRMPaymentTermOptionId(OptionId: Integer)
    begin
        CurrentlyMappedCRMPaymentTermOptionId := OptionId;
    end;

    procedure GetRec(OptionId: Integer): Record "CRM SAT Tax Scheme"
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

#pragma implicitwith restore
