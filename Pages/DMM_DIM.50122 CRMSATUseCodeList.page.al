#pragma implicitwith disable
page 50122 "CRM SAT Use Code"


{
    ApplicationArea = Suite;
    Caption = 'SAT Use Code - Dataverse';
    AdditionalSearchTerms = 'CFDI Purpose';
    Editable = false;
    PageType = List;
    SourceTable = "CRM SAT Use Code";
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
                ToolTip = 'Generate the entity from the coupled Dataverse SAT USE  Code.';
                Visible = OptionMappingEnabled;

                trigger OnAction()
                var
                    CRMPaySATUseCode: Record "CRM SAT Use Code";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CRMPaySATUseCode.Copy(Rec, true);
                    CurrPage.SetSelectionFilter(CRMPaySATUseCode);
                    CRMIntegrationManagement.CreateNewRecordsFromSelectedCRMOptions(CRMPaySATUseCode);
                end;
            }
            action(ShowOnlyUncoupled)
            {
                ApplicationArea = Suite;
                Caption = 'Hide Coupled SAT USE Code';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Do not show coupled SAT USE Code.';

                trigger OnAction()
                begin
                    Rec.MarkedOnly(true);
                end;
            }
            action(ShowAll)
            {
                ApplicationArea = Suite;
                Caption = 'Show Coupled SAT USE Code';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show coupled SAT Use Code.';

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
        if CRMOptionMapping.FindRecordID(Database::"CRM Account", CRMAccount.FieldNo(SatusecodeCodeEnum), Rec."Option Id") then
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

    procedure GetRec(OptionId: Integer): Record "CRM SAT Use Code"
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
