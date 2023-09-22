#pragma implicitwith disable
page 50109 " CRM Post Code List"
{
    PageType = List;
    SourceTable = "CDS dmm_PostCode";
    Editable = false;
    ApplicationArea = suite;
    UsageCategory = Lists;
    Caption = 'Post Code - Dataverse';
    AdditionalSearchTerms = 'Country CDS, Country Common Data Service';

    SourceTableView = SORTING(dmm_PostCode);


    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(dmm_City; Rec.dmm_City)
                {
                    ApplicationArea = Suite;
                    Caption = 'City';
                    ToolTip = 'Specifies if the Dataverse record is coupled to Business Central.';
                }

                field(dmm_PostCode; Rec.dmm_PostCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Post Code';
                    //  StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }
                field(dmm_County; Rec.dmm_County)
                {
                    ApplicationArea = Suite;
                    Caption = 'County';
                    ToolTip = 'Specifies data from a corresponding field in a Dataverse entity. For more information about Dataverse, see Dataverse Help Center.';
                }


                field("Coupled to CRM"; Rec."Coupled to CRM")
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dataverse record is coupled to Business Central.';
                }

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
                    DataverseWorker: Record "CDS dmm_PostCode";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(DataverseWorker);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(DataverseWorker);
                end;
            }
        }
    }

    var
        CurrentlyCoupledDataverseWorker: Record "CDS dmm_PostCode";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledDataverseWorker(DataverseWorker: Record "CDS dmm_PostCode")
    begin
        CurrentlyCoupledDataverseWorker := DataverseWorker;
    end;
}
#pragma implicitwith restore
